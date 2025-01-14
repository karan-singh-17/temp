import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/configuratorscreen/ConfiguratorScreen.dart';
import 'package:moe/screens/views/dashboard/DashboardScreen.dart';
import 'package:moe/screens/views/profileandsettingscreen/ProfileSettingScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';
import '../dashboard/dashboard_multiple.dart';

class CurrentProductionscreen extends StatefulWidget {
  const CurrentProductionscreen({super.key});

  @override
  State<CurrentProductionscreen> createState() =>
      _CurrentProductionscreenState();
}

class _CurrentProductionscreenState extends State<CurrentProductionscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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

                    ///Navigate to dashboard screen
                  ));
            }, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profilesettingscreen(),

                    ///Navigate to setting screen
                  ));
            }, context),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  firstCardDesign(),

                  ///current production card design
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    height: 420,
                    width: double.infinity,
                    child: Stack(children: [
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Image.asset("assets/images/pannelimagebig.png",
                            height: 300),
                      ),
                      Positioned(
                        left: 20,
                        top: 50,
                        child: Row(
                          children: [
                            Text("AKTUELLER \nNEIGUNGSWINKEL",
                                style: fontStyling(
                                  12.0,
                                  FontWeight.w600,
                                  context.isDarkMode ? white : black,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Text("82%",
                                style: fontStyling(
                                  24.0,
                                  FontWeight.w700,
                                  context.isDarkMode ? white : black,
                                )),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 150,
                        child: Row(
                          children: [
                            Text("AKTUELLER \nWIRKUNGSGRAD",
                                style: fontStyling(
                                  12.0,
                                  FontWeight.w600,
                                  context.isDarkMode ? white : black,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Text("82%",
                                style: fontStyling(
                                  24.0,
                                  FontWeight.w700,
                                  context.isDarkMode ? white : black,
                                )),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 270,
                        child: Row(
                          children: [
                            Text("AKTUELLER \nWIRKUNGSGRAD",
                                style: fontStyling(
                                  12.0,
                                  FontWeight.w600,
                                  context.isDarkMode ? white : black,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Text("82%",
                                style: fontStyling(
                                  24.0,
                                  FontWeight.w700,
                                  context.isDarkMode ? white : black,
                                )),
                          ],
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            )),
            bottomButton(),

            ///button design
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  ///current production card design
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
            Text("AKTUELLE \nPRODUKTION",
                style: fontStyling(
                    25.0, FontWeight.w700, primaryLightBackgroundColor)),
            const Spacer(),
            Container(
              child: Row(
                children: [
                  Text("760",
                      style: fontStyling(
                          45.0, FontWeight.w700, primaryLightBackgroundColor)),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 10),
                    child: Text("W",
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

  ///button design
  bottomButton() {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const ConfiguratorScreen(),
        //     ));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: containerBlack, borderRadius: BorderRadius.circular(50)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("KONFIGURATOR",
                    style: fontStyling(
                        16.0, FontWeight.w700, primaryLightBackgroundColor)),
              ),
              const Spacer(),
              SvgPicture.asset(
                "assets/images/dashboardcrossarrow.svg",
                height: 30,
                width: 30,
              )
            ]),
          ],
        ),
      ),
    );
  }
}
