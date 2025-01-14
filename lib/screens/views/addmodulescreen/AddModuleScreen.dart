import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/domain/helper/database_online.dart';
import 'package:moe/screens/views/add_panel/name_page.dart';
import 'package:moe/screens/views/add_panel/pannel_details.dart';
import 'package:moe/screens/views/bluetoothconnectscreen/DeviceAddingScreen.dart';
import 'package:moe/screens/views/currentchargingstatusscreen/CurrentChargeStatusScreen.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:moe/screens/views/pannel_details/pannel_details.dart';
import 'package:provider/provider.dart';

import '../../../data/services/AWS/IoTLamda/iot_data_model.dart';
import '../../../data/services/AWS/IoTLamda/system_provider.dart';
import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/Database_Helper(local).dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';
import '../profileandsettingscreen/ProfileSettingScreen.dart';

class AddModuleScreen extends StatefulWidget {
  String selec_id;
  AddModuleScreen({super.key, required this.selec_id});

  @override
  State<AddModuleScreen> createState() => _AddModuleScreenState();
}

class _AddModuleScreenState extends State<AddModuleScreen> {
  List<Map<String, dynamic>> pannels = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    print(widget.selec_id);
    print(widget.selec_id);
    getPannels();
  }

  Future<void> getPannels() async {
    try {
      // Fetch the JSON file from S3
      Map<String, dynamic>? tempes = await S3PanelService().downloadFile("${widget.selec_id}.json");

      // Check if tempes is non-null and contains 'panels'
      if (tempes != null && tempes.containsKey('panels') && tempes['panels'] != null) {
        // Convert 'panels' to a List<Map<String, dynamic>>
        List<dynamic> temp = tempes['panels'];
        List<Map<String, dynamic>> panels = List<Map<String, dynamic>>.from(temp);

        setState(() {
          pannels = panels;
          print("Success");
          print(pannels);
          loading = false;
        });
      } else {
        // Handle case where 'panels' is missing or null
        setState(() {
          pannels = [];
          print("No panels found.");
          loading = false;
        });
      }
    } catch (e) {
      print("Error fetching systems: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: true);

    System system = (deviceProvider.devices.length > 1)
        ? deviceProvider.devices
            .firstWhere((system) => system.id == widget.selec_id)
        : deviceProvider.devices[0];

    return Scaffold(
      backgroundColor: context.isDarkMode ? black : primaryLightBackgroundColor,
      body: (loading) ? Center(
        child: CircularProgressIndicator(
          color: !context.isDarkMode ? black : primaryLightBackgroundColor,
        ),
      ): SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          //color: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 30,
              ),
              const SizedBox(height: 30),
              Text(
                'Meine Paneele',
                style: fontStyling(
                    30.0, FontWeight.w700, context.isDarkMode ? white : black),
              ),
              const SizedBox(height: 20),
              for (int i = 0; i < system.batteries.length; i++)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading for each battery
                      Text(
                        "Batterie ${i + 1}",
                        style: fontStyling(
                          20.0,
                          FontWeight.w500,
                          context.isDarkMode ? white : black,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _roundCircleDesign(
                            pannels.any((panel) =>
                                    panel['battery_no'] == i.toString() &&
                                    panel['panel_no'] == "1")
                                ? 'assets/images/cont_pannel.svg'
                                : 'assets/images/settingplusicon.svg', // Conditional icon
                            pannels.firstWhere(
                              (panel) =>
                                  panel['battery_no'] == i.toString() && panel['panel_no'] == "1",
                              orElse: () =>
                                  {'name': 'PANEL 1'}, // Default if not found
                            )['name'], // Use panel name if it exists
                            () {
                              bool panelExists = pannels.any((panel) =>
                                  panel['battery_no'] == i.toString() && panel['panel_no'] == "1");

                              if (panelExists) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => PannelDetails_real(
                                      lams: pannels.firstWhere((panel) =>
                                          panel['battery_no'] == i.toString() &&
                                          panel['panel_no'] == "1"),
                                      index:
                                          i, // or use index if specific to a loop
                                    ),
                                  ),
                                ).then((_) {
                                  getPannels();
                                });
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => name_page(
                                      sys_id: widget.selec_id,
                                      bat_no: i,
                                      pan_no: 1,
                                    ),
                                  ),
                                ).then((_) {
                                  getPannels();
                                });
                              }
                            },
                          ),
                          SizedBox(width: 20),
                          _roundCircleDesign(
                            pannels.any((panel) =>
                                    panel['battery_no'] == i.toString() &&
                                    panel['panel_no'] == "2")
                                ? 'assets/images/cont_pannel.svg'
                                : 'assets/images/settingplusicon.svg', // Conditional icon
                            pannels.firstWhere(
                              (panel) =>
                                  panel['battery_no'] == i.toString() && panel['panel_no'] == "2",
                              orElse: () =>
                                  {'name': 'PANEL 2'}, // Default if not found
                            )['name'], // Use panel name if it exists
                            () {
                              bool panelExists = pannels.any((panel) =>
                                  panel['battery_no'] == i.toString() && panel['panel_no'] == "2");
                              if (panelExists) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => PannelDetails_real(
                                      lams: pannels.firstWhere((panel) =>
                                          panel['battery_no'] == i.toString() &&
                                          panel['panel_no'] == "2"),
                                      index:
                                          i,
                                    ),
                                  ),
                                ).then((_) {
                                  getPannels();
                                });
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => name_page(
                                      sys_id: widget.selec_id,
                                      bat_no: i,
                                      pan_no: 2,
                                    ),
                                  ),
                                ).then((_) {
                                  getPannels();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              // Container(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       _roundCircleDesign(
              //           'assets/images/settingplusicon.svg', 'PANEL', () {
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (context) => name_page(
              //         //       sys_id: widget.selec_id,
              //         //       bat_no: ,
              //         //       pan_no: ,
              //         //     ),
              //         //   ),
              //         // ).then((_) {
              //         //   getPannels();
              //         // });
              //       }),
              //       const SizedBox(width: 10),
              //       Expanded(
              //         child: SizedBox(
              //           height: 120,
              //           child: ListView.builder(
              //             padding: EdgeInsets.only(right: 10),
              //             scrollDirection: Axis.horizontal,
              //             itemCount: pannels.length,
              //             itemBuilder: (context, index) {
              //               return _roundCircleDesign(
              //                 "assets/images/cont_pannel.svg",
              //                 pannels[index]['name'],
              //                 () {
              //                   Navigator.push(
              //                       context,
              //                       CupertinoPageRoute(
              //                           builder: (context) => PannelDetails_real(
              //                                 sys_id: pannels[index]['id'],
              //                             index: index
              //                               ))).then((_) {
              //                     getPannels();
              //                   });
              //                 },
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  ///Round Svg with text
  Widget _roundCircleDesign(String svgImage, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    context.isDarkMode ? containerBlack : greyForSettingRound,
                borderRadius: BorderRadius.circular(400),
              ),
              child: SvgPicture.asset(
                svgImage,
                color:
                    context.isDarkMode ? greyForSettingRound : containerBlack,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: fontStyling(
                13.0,
                FontWeight.w400,
                context.isDarkMode ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
