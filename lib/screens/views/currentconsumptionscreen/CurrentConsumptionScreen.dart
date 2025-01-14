import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moe/data/services/AWS/IoTLamda/iot_data_model.dart';
import 'package:moe/domain/helper/Colors.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/history_graphs/history-graph.dart';

import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';
import '../dashboard/DashboardScreen.dart';
import '../dashboard/dashboard_multiple.dart';
import '../profileandsettingscreen/ProfileSettingScreen.dart';

class CurrentConsumptionScreen extends StatefulWidget {
  Inverter inverter;
  int avg_pow;
  CurrentConsumptionScreen(
      {super.key, required this.inverter, required this.avg_pow});

  @override
  State<CurrentConsumptionScreen> createState() =>
      _CurrentConsumptionScreenState();
}

class _CurrentConsumptionScreenState extends State<CurrentConsumptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 20,
            ),
            topNavigation(() {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardMultiple(),
                  ));
            }, () {
              ///Navigate to setting screen
            }, context),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    firstCardDesign(widget.avg_pow),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                          color: containerBlack,
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text("LEISTUNG WECHSELRICHTER",
                                  style: fontStyling(15.0, FontWeight.w700,
                                      primaryLightBackgroundColor)),
                            ),
                            Text("  45",
                                style: fontStyling(25.0, FontWeight.w700,
                                    primaryLightBackgroundColor)),
                            Text(" W",
                                style: fontStyling(25.0, FontWeight.w300,
                                    primaryLightBackgroundColor)),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Text("HEUTE",
                          style: fontStyling(17.0, FontWeight.w500,
                              primaryLightBackgroundColor)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 35, horizontal: 20),
                      decoration: BoxDecoration(
                          color: containerBlack,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("(TO-DO) Graph In Progress...",
                          style: fontStyling(17.0, FontWeight.w500,
                              primaryLightBackgroundColor)),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // First Icon
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFD9D9D9),
                                ),
                                child: Icon(
                                  Icons.add_outlined,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 13),
                              Text('STROMPREIS',
                                  style: fontStyling(12.0, FontWeight.w400,
                                      primaryLightBackgroundColor)),
                            ],
                          ),
                          // Second Icon
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFD9D9D9),
                                ),
                                child: Icon(
                                  Icons.person_outline_sharp,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 13),
                              Text('LASTPROFIL',
                                  style: fontStyling(12.0, FontWeight.w400,
                                      primaryLightBackgroundColor)),
                            ],
                          ),
                          // Third Icon
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              History_graph()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                  child: Icon(
                                    weight: 22,
                                    Icons.stacked_line_chart,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 13), // Spacing between icon and text
                              Text('HISTORIE',
                                  style: fontStyling(12.0, FontWeight.w400,
                                      primaryLightBackgroundColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Card design for current consumption screen
  firstCardDesign(int avg) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      decoration: BoxDecoration(
          color: containerBlack, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text("AKTUELLER \nVERBRAUCH",
                  style: fontStyling(
                      22.0, FontWeight.w700, primaryLightBackgroundColor)),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${avg}",
                      style: fontStyling(
                          40.0, FontWeight.w700, primaryLightBackgroundColor)),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 5),
                    child: Text("  W",
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
}
