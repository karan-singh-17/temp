import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/onboarding/features/bluetooth_not_open.dart';
import 'package:moe/onboarding/features/search_bt_devices/view/search_device_page.dart';
import 'package:moe/screens/views/shelly/shelly_home.dart';

import '../../domain/classes/utils.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? black : primaryLightBackgroundColor,
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        width: MediaQuery.of(context).size.width * 0.09,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: InkWell(
          onTap: () async {
            (await FlutterBluePlus.isOn)
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchDevicePage()))
                : Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Bluetooth_Close()));
          },
          child: Container(
            decoration: BoxDecoration(
                color: context.isDarkMode ? white : black,
                borderRadius: BorderRadius.circular(40)),
            child: Center(
              child: Text(
                "Verbinde meinen Akku",
                style: fontStyling(
                  16.0,
                  FontWeight.w700,
                  !context.isDarkMode ? white : black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40,
            ),
            SvgPicture.asset(context.isDarkMode
                ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                : "assets/images/deviceaddscreenappiconforlightmode.svg"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.16,
            ),
            Container(
                padding: EdgeInsets.only(left: 35, right: 35),
                child: Image.asset("assets/images/invertoraloneimage.png")),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: "schalte das Gerät ein\n",
                        style: fontStyling(
                          24.0,
                          FontWeight.w800,
                          context.isDarkMode ? white : black,
                        )),
                    TextSpan(
                      text: "\n",
                    ),
                    TextSpan(
                        text: "Schalten Sie Ihr Batteriegerät ein, indem\n",
                        style: fontStyling(
                          14.0,
                          FontWeight.w400,
                          context.isDarkMode ? white : black,
                        )),
                    TextSpan(
                        text: "Sie  die Taste darauf drücken.",
                        style: fontStyling(
                          14.0,
                          FontWeight.w400,
                          context.isDarkMode ? white : black,
                        )),
                  ],
                ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
