import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';

class Turnonbluetoothscreen extends StatefulWidget {
  const Turnonbluetoothscreen({super.key});

  @override
  State<Turnonbluetoothscreen> createState() => _TurnonbluetoothscreenState();
}

class _TurnonbluetoothscreenState extends State<Turnonbluetoothscreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        SystemNavigator.pop();

        ///invoke SystemNavigator.pop() on device back
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: context.isDarkMode ? black : primaryLightBackgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 40,
                      ),
                      SvgPicture.asset(context.isDarkMode
                          ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                          : "assets/images/deviceaddscreenappiconforlightmode.svg"),
                      const SizedBox(
                        height: 25,
                      ),
                      Text('Bluetooth-Finder',
                          style: fontStyling(
                            20.0,
                            FontWeight.w600,
                            context.isDarkMode ? white : black,
                          )),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 310,
                        child: Stack(children: [
                          SvgPicture.asset(
                            context.isDarkMode
                                ? "assets/images/multicirclebluetoothfordarkmode.svg"
                                : "assets/images/multicirclebluetoothforlightmode.svg",
                            height: 330,
                          ),
                          Positioned(
                              top: 100,
                              child: Image.asset(
                                "assets/images/smallbatteryimage.png",
                                height: 27,
                                width: 31,
                              )),
                          Positioned(
                              left: 200,
                              top: 20,
                              child: Image.asset(
                                "assets/images/smallbatteryimage.png",
                                height: 27,
                                width: 31,
                              )),
                          Positioned(
                              top: 220,
                              left: 80,
                              child: Image.asset(
                                "assets/images/twosmallbatteryimage.png",
                                height: 38,
                                width: 31,
                              )),
                          Positioned(
                              top: 170,
                              left: 270,
                              child: Image.asset(
                                "assets/images/threesmallbatteryimage.png",
                                height: 49,
                                width: 31,
                              )),
                        ]),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text("schalten Sie Bluetooth ein",
                          style: fontStyling(
                            25.0,
                            FontWeight.w700,
                            context.isDarkMode ? white : black,
                          )),
                      Text(
                        "Um Ihr tragbares Gerät mit der App zu verbinden, stellen Sie sicher, dass Ihr Bluetooth eingeschaltet ist",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: grey,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              solidColorMainUiButton(() async {
                AppSettings.openAppSettings(type: AppSettingsType.bluetooth);

                ///open bluetooth setting of device
              },
                  "schalten Sie Bluetooth ein",
                  context.isDarkMode ? white : black,
                  context.isDarkMode ? black : white),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
