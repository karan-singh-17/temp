import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/Database_Helper(local).dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/domain/helper/database_online.dart';
import 'package:moe/screens/views/configuratorscreen/ConfiguratorScreen.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:moe/screens/views/pannel_details/pannel_graph.dart';
import 'package:provider/provider.dart';

import '../../../data/services/AWS/IoTLamda/iot_data_model.dart';
import '../../../data/services/AWS/IoTLamda/system_provider.dart';
import '../../../domain/classes/utils.dart';

class PannelDetails_real extends StatefulWidget {
  Map<String , dynamic> lams;
  int index;

  PannelDetails_real({super.key, required this.lams , required this.index});

  @override
  State<PannelDetails_real> createState() => _PannelDetailsState();
}

class _PannelDetailsState extends State<PannelDetails_real> {
  late Map<String , dynamic> pannel;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPannels();
  }
  Future<void> getPannels() async {
    try {
      Map<String, dynamic>? temp = widget.lams;
      //print(await DatabaseHelper().getSystemById(2));

      if (temp != null) {
        setState(() {
          pannel = temp;
          print("Success");
          isLoading = false;
        });
      } else {
        print("No system found with ID: ");
      }
    } catch (e) {
      print("Error fetching systems: $e");
    }
  }

  int aktul_prod = 0;


  @override
  Widget build(BuildContext context) {

    final deviceProvider = Provider.of<DeviceProvider>(context, listen: true);
    System system = (deviceProvider.devices.length > 1)
        ? deviceProvider.devices
        .firstWhere((system) => system.id == pannel["systemId"])
        : deviceProvider.devices[0];
    if(widget.index < system.solarPanels.length){
      Solar solar = system.solarPanels[widget.index];
      setState(() {
        aktul_prod = int.parse(solar.busPower);
      });
    }

    return Scaffold(
      backgroundColor: context.isDarkMode ? black : primaryLightBackgroundColor,
      body: (isLoading == true) ? CircularProgressIndicator(
        backgroundColor:context.isDarkMode ? black : primaryLightBackgroundColor ,
        color: !context.isDarkMode ? black : primaryLightBackgroundColor ,
      ) : Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Container(
            padding: EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            width: double.infinity,
            child: IconButton.outlined(onPressed: () async{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: !context.isDarkMode? black : white,
                    title: Text('Confirmation' ,style: fontStyling(22.0, FontWeight.w500, context.isDarkMode? black : white)),
                    content: Text('Möchten Sie mit dem Löschen von ${pannel["name"]} fortfahren?' , style: fontStyling(16.0, FontWeight.w400, context.isDarkMode? black : white)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel' , style: fontStyling(16.0, FontWeight.w400, context.isDarkMode? black : white)),
                      ),
                      TextButton(
                        onPressed: () async {
                          //Navigator.of(context).pop();
                          try {
                            bool result = await S3PanelService().deletePanel("${pannel['systemId']}.json", '${pannel['battery_no']}' , '${pannel['panel_no']}');
                            //int result = await DatabaseHelper().deleteSystem(pannel["id"]);
                            if (result) {
                              // Show confirmation Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('System deleted successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.popUntil(context, ModalRoute.withName('/addModule'));
                            } else {
                              // Show error Snackbar if no rows were deleted
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('System not found.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (error) {
                            // Show error Snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting system: $error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          // Close the dialog
                          //_navigateToScreenD(context); // Navigate to Screen D
                        },
                        child: Text('Yes' , style: fontStyling(16.0, FontWeight.w400, context.isDarkMode? black : white)),
                      ),
                    ],
                  );
                },
              );
            }, icon: Icon(Icons.delete_outline_sharp, size: 33 , color: !context.isDarkMode ? black : white,)),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          GestureDetector(
            onTap: (){
              print("lat: ${pannel["latitude"].toString()} , long:${pannel["longitude"]
                  .toString()} ,azi:${pannel["azimuth"].toString()} , kap:${pannel["capacity"]
                  .toString()} , ang: ${pannel["angle"].toString()}");
              Navigator.push(context, CupertinoPageRoute(builder: (context) => pannel_graph(lat: pannel["latitude"] , long:pannel["longitude"] ,azi:pannel["azimuth"].toString() , kap:pannel["capacity"].toString() , ang: pannel["angle"].toString(),)));
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: containerBlack,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    pannel['name'],
                    style: fontStyling(25.0, FontWeight.w700, white),
                  ),
                  const SizedBox(height: 19),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("AKTUELLE\nPRODUKTION",
                          style: fontStyling(20.0, FontWeight.w700, white)),
                      Text(
                        "${aktul_prod} W",
                        style: fontStyling(30.0, FontWeight.w700, white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "AKTUELLER\nNEIGUNGSWINKEL",
                          style: fontStyling(12.0, FontWeight.w500,
                              context.isDarkMode ? white : black),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "${pannel['angle'].roundToDouble().toStringAsFixed(1)} °",
                          style: fontStyling(17.0, FontWeight.w700,
                              context.isDarkMode ? white : black),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "AKTUELLER\nWIRKUNGSGRAD",
                          style: fontStyling(12.0, FontWeight.w500,
                              context.isDarkMode ? white : black),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "${pannel['angle'].roundToDouble().toStringAsFixed(1)} %",
                          style: fontStyling(17.0, FontWeight.w700,
                              context.isDarkMode ? white : black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "MÖGLICHER\nWIRKUNGSGRAD",
                          style: fontStyling(12.0, FontWeight.w500,
                              context.isDarkMode ? white : black),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "${pannel['angle'].roundToDouble().toStringAsFixed(1)} %",
                          style: fontStyling(17.0, FontWeight.w700,
                              context.isDarkMode ? white : black),
                        ),
                      ],
                    ),
                    SizedBox(height: 90,),

                    firstCardDesign(),
                  ],
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 420,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/new_pannel.png",
                      height: 510,
                      width: 210,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  firstCardDesign() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ConfiguratorScreen(pannel: pannel,),
            )).then((_){
              getPannels();
        });
        },
      child: Container(
        //width: double.infinity,
        padding: const EdgeInsets.only(left: 10 , right: 10 , top: 10 , bottom : 10),
        decoration: BoxDecoration(
            color: containerBlack, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("KONFIGURATOR" , style : fontStyling(16.0, FontWeight.w500,
                context.isDarkMode ? white : black),),
            SizedBox(width: 10,),
            SvgPicture.asset(
              "assets/images/dashboardcrossarrow.svg",
              height: 24,
              width: 24,
            )
          ],
        )
      ),
    );
  }
}
