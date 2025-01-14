import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/data/services/AWS/IoTLamda/system_provider.dart';
import 'package:moe/domain/classes/utils.dart' as theme;
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:provider/provider.dart';

import '../../../data/services/AWS/IoTLamda/iot_data_model.dart';
import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';
import '../dashboard/DashboardScreen.dart';
import '../dashboard/dashboard_multiple.dart';
import '../profileandsettingscreen/ProfileSettingScreen.dart';

class BatteryCharegeStatusScreen extends StatefulWidget {
  List<Battery> batteries;
  int average_batt;
  BatteryCharegeStatusScreen(
      {super.key, required this.batteries, required this.average_batt});

  @override
  State<BatteryCharegeStatusScreen> createState() =>
      _BatteryCharegeStatusScreenState();
}

class _BatteryCharegeStatusScreenState
    extends State<BatteryCharegeStatusScreen> {
  @override
  void initState() {
    print("Step 1");
    super.initState();
    print("Step 2");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      temp();
    });
    print("Step 4453");
  }

  temp() async{
    print("Step 3");
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    print("Step 4");
    deviceProvider.calculateAverageBatteryPercentage();
    print("Step 5");
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: true);

    return Scaffold(
      body: Container(
        color: theme.ThemeProperties(context: context).scColor,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 20,
            ),

            ///top header
            topNavigation(() {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardMultiple(),
                  ));
            }, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profilesettingscreen(),
                  ));
            }, context),
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    firstCardDesign(deviceProvider),
                    const SizedBox(
                      height: 10,
                    ),
                    bottomFirstCard(),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: (widget.batteries.length == 1)
                          ? oneBattery(widget: widget)
                          : twoBatteries(widget: widget),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Card for CURRENT CHARGING STATUS
  firstCardDesign(DeviceProvider deviceProvider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
          color: containerBlack, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text("AKTUELLE \nLADEZUSTAND",
                  style: fontStyling(
                      25.0, FontWeight.w700, primaryLightBackgroundColor)),
            ),
            Container(
              child: Row(
                children: [
                  Text("${deviceProvider.averageBatteryPercentage}",
                      style: fontStyling(
                          50.0, FontWeight.w700, primaryLightBackgroundColor)),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 10),
                    child: Text("%",
                        style: fontStyling(25.0, FontWeight.w300,
                            primaryLightBackgroundColor)),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  bottomFirstCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: containerBlack, borderRadius: BorderRadius.circular(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text("ZEIT BIS VOLLSTÄNDIG GELADEN:",
                  style: fontStyling(
                      16.0, FontWeight.w700, primaryLightBackgroundColor)),
            ),
            Text('3h',
                style: fontStyling(
                    24.0, FontWeight.w700, primaryLightBackgroundColor))
          ]),
        ],
      ),
    );
  }
}

class twoBatteries extends StatelessWidget {
  const twoBatteries({
    super.key,
    required this.widget,
  });

  final BatteryCharegeStatusScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Stack(children: [
        Positioned(
            right: 50,
            bottom: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/blackline.svg",
                  width: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${widget.batteries[1].stateOfCharge}%",
                        style: GoogleFonts.roboto(
                            color:
                                theme.ThemeProperties(context: context).txColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.batteries[1].busPower}Wh",
                        style: GoogleFonts.roboto(
                            color:
                                theme.ThemeProperties(context: context).txColor,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            )),
        Positioned(
            right: 50,
            bottom: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/blackline.svg",
                  width: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${widget.batteries.first.stateOfCharge}%",
                        style: GoogleFonts.roboto(
                            color:
                                theme.ThemeProperties(context: context).txColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.batteries.first.busPower}Wh",
                        style: GoogleFonts.roboto(
                            color:
                                theme.ThemeProperties(context: context).txColor,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            )),
        Positioned(
            left: -20,
            bottom: -80,
            child: Image.asset(
              "assets/images/battery_size_two.png",
              height: 400,
              width: 300,
              fit: BoxFit.fitHeight,
            )),
      ]),
    );
  }
}

class oneBattery extends StatelessWidget {
  const oneBattery({
    super.key,
    required this.widget,
  });

  final BatteryCharegeStatusScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Stack(children: [
        Positioned(
            right: 50,
            bottom: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/blackline.svg",
                  width: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${widget.batteries.first.stateOfCharge}%",
                        style: GoogleFonts.roboto(
                            color:
                                theme.ThemeProperties(context: context).txColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.batteries.first.busPower}Wh",
                        style: GoogleFonts.roboto(
                            color:
                                theme.ThemeProperties(context: context).txColor,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            )),
        Positioned(
            left: -20,
            bottom: -80,
            child: Image.asset(
              "assets/images/battery_size_one.png",
              height: 400,
              width: 300,
              fit: BoxFit.fitHeight,
            )),
      ]),
    );
  }
}
