import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/domain/helper/UtilHelper.dart';
import 'package:moe/screens/views/addmodulescreen/AddModuleScreen.dart';
import 'package:moe/screens/views/dashboard/DashboardScreen.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:moe/screens/views/profileandsettingscreen/UserProfileScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../currentchargingstatusscreen/CurrentChargeStatusScreen.dart';

class Profilesettingscreen extends StatefulWidget {
  const Profilesettingscreen({super.key});

  @override
  State<Profilesettingscreen> createState() => _ProfilesettingscreenState();
}

class _ProfilesettingscreenState extends State<Profilesettingscreen> {
  ///Declaring variable
  final _settingOptionList = [
    "EINSTELLUNGEN",
    "BENUTZERPROFIL",
    "KONTOVERWALTUNG",
    'FAQ',
    "RECHTLICHES",
    'FEEDBACK'
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        ///Navigate to dashboard screen on system back invoked
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardMultiple(),
            ));
      },
      child: Scaffold(
        body: Container(
          color: context.isDarkMode ? black : primaryLightBackgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 30,
              ),

              ///top navigation header
              topNavigationWithoutprofileIcon(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardMultiple(),
                    ));

                ///Navigate to dashboard screen
              }, context),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "DEIN SYSTEM",
                            style: fontStyling(30.0, FontWeight.w700,
                                context.isDarkMode ? white : black),
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "35",
                                style: fontStyling(50.0, FontWeight.w700,
                                    context.isDarkMode ? white : black),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 5),
                                child: Text(
                                  "%",
                                  style: fontStyling(25.0, FontWeight.w300,
                                      context.isDarkMode ? white : black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "MEINE MODULE",
                        style: fontStyling(20.0, FontWeight.w400,
                            context.isDarkMode ? white : black),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    addedHardware(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      optionCardDesign(_settingOptionList[0], () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const AddModuleScreen(),
                        //     ));

                        ///Navigate to add module screen
                      }),
                      optionCardDesign(_settingOptionList[1], () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserProfileScreen(),
                            ));

                        ///navigate to user profile screen
                      }),
                      optionCardDesign(_settingOptionList[2], () {}),
                      optionCardDesign(_settingOptionList[3], () {}),
                      optionCardDesign(_settingOptionList[4], () {}),
                      optionCardDesign(_settingOptionList[5], () {}),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///scrollview with added hardware design
  addedHardware() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          _profileRoundCircleDesign('assets/images/settingplusicon.svg', "NEU",
              () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const AddModuleScreen(),
            //     ));
          }),
          const SizedBox(
            width: 20,
          ),
          _profileRoundCircleDesign(
              'assets/images/settingpanelicon.svg', "MoePanel", () {}),
          const SizedBox(
            width: 20,
          ),
          _profileRoundCircleDesign(
              'assets/images/settingbatteryicon.svg', "MoeBat 1", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrentChargeStatusScreen(),
                ));
          }),
          const SizedBox(
            width: 20,
          ),
          _profileRoundCircleDesign(
              'assets/images/settingbatteryicon.svg', "MoeBat 2", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrentChargeStatusScreen(),
                ));
          }),
          const SizedBox(
            width: 20,
          ),
          _profileRoundCircleDesign('assets/images/morethreedot.svg', "MEHR",
              () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const AddModuleScreen(),
            //     ));
          }),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  ///added hardware design
  _profileRoundCircleDesign(svgImage, text, VoidCallback) {
    return GestureDetector(
      onTap: () {
        VoidCallback();
      },
      child: Column(
        children: [
          Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color:
                      context.isDarkMode ? containerBlack : greyForSettingRound,
                  borderRadius: BorderRadius.circular(400)),
              child: SvgPicture.asset('$svgImage',
                  color: context.isDarkMode
                      ? greyForSettingRound
                      : containerBlack)),
          const SizedBox(
            height: 10,
          ),
          Text(
            "$text",
            style: fontStyling(
                11.0, FontWeight.w400, context.isDarkMode ? white : black),
          )
        ],
      ),
    );
  }

  ///setting options
  optionCardDesign(optionTitle, VoidCallback) {
    return GestureDetector(
      onTap: () {
        VoidCallback();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                    color: containerBlack,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "$optionTitle",
                  style: fontStyling(20.0, FontWeight.w400, white),
                )),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
