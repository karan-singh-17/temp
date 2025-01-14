import 'package:flutter/material.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/profileandsettingscreen/ProfileSettingScreen.dart';
import 'package:moe/screens/views/profileandsettingscreen/UserProfileScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';

class CurrentChargeStatusScreen extends StatefulWidget {
  const CurrentChargeStatusScreen({super.key});

  @override
  State<CurrentChargeStatusScreen> createState() =>
      _CurrentChargeStatusScreenState();
}

class _CurrentChargeStatusScreenState extends State<CurrentChargeStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 20,
            ),

            ///top header
            topNavigation(() {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profilesettingscreen(),
                  ));

              ///Navigate to setting screen
            }, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(),
                  ));

              ///Navigate to user profile screen
            }, context),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    firstCardDesign(),

                    ///Design for card showing current charging status
                    const SizedBox(
                      height: 30,
                    ),
                    bottomFirstCard(),

                    ///Design for showing time to fully charged
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 400,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 8,
                            bottom: 0,
                            child: Image.asset(
                              context.isDarkMode
                                  ? "assets/images/bataloneiconfordarkmode.png"
                                  : "assets/images/batalonimage.png",
                              width: 224,
                              height: 178,
                            ),
                          ),
                          Positioned(
                            left: 8,
                            bottom: 75,
                            child: Image.asset(
                              context.isDarkMode
                                  ? "assets/images/bataloneiconfordarkmode.png"
                                  : "assets/images/batalonimage.png",
                              width: 224,
                              height: 178,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 145,
                            child: Image.asset(
                              "assets/images/invertoraloneimage.png",
                              width: 226,
                              height: 178,
                            ),
                          ),
                          Positioned(
                            left: 246,
                            bottom: 115,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('20%',
                                    style: fontStyling(24.0, FontWeight.w700,
                                        context.isDarkMode ? white : black)),
                                Text("x,xx kWh",
                                    style: fontStyling(20.0, FontWeight.w400,
                                        context.isDarkMode ? white : black)),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 246,
                            bottom: 35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('50%',
                                    style: fontStyling(24.0, FontWeight.w700,
                                        context.isDarkMode ? white : black)),
                                Text("0,75 kWh",
                                    style: fontStyling(20.0, FontWeight.w400,
                                        context.isDarkMode ? white : black)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  ///Design for card showing current charging status
  firstCardDesign() {
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
                  Text("35",
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

  ///Design for showing time to fully charged
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
