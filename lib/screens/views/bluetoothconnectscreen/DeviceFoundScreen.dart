import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/bluetoothconnectscreen/DeviceAddingScreen.dart';
import 'package:moe/screens/views/bluetoothconnectscreen/QrScannerScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';

class DeviceFoundScreen extends StatefulWidget {
  const DeviceFoundScreen({super.key});

  @override
  State<DeviceFoundScreen> createState() => _DeviceFoundScreenState();
}

class _DeviceFoundScreenState extends State<DeviceFoundScreen> {
  ///declaring variables
  var _clickedDevice = "0";
  final _deviceStaticValue = [
    {"name": "Akku 1", "image": 'assets/images/batalonefordevicefound.png'},
    {"name": "Akku 2", "image": 'assets/images/twobatimagefordevicefounnd.png'},
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        ///Navigate to device adding screen on system back
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeviceAddingScreen(),
          ),
        );
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
                      Text('Suchen Sie 2 Geräte',
                          style: fontStyling(
                            20.0,
                            FontWeight.w600,
                            context.isDarkMode ? white : black,
                          )),
                      Text(
                        "Wählen Sie das Gerät aus und klicken \nSie auf die Schaltfläche",
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

                      ///showing all bluetooth device available
                      for (var i = 0; i < _deviceStaticValue.length; i++)
                        customDeviceFoundDesign(_deviceStaticValue[i]["name"],
                            _deviceStaticValue[i]["image"], () {
                          _clickedDevice = "$i";
                          setState(() {});
                        }, i, _clickedDevice),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              borderMainUiButton(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeviceAddingScreen(),
                    ));

                ///Navigate to device adding screen
              }, "das Gerät nicht sehen", context.isDarkMode ? white : black,
                  context.isDarkMode ? white : black),
              const SizedBox(
                height: 15,
              ),
              solidColorMainUiButton(() async {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const QrScannerScreen(),
                //     ));

                ///Navigate to QR scanner screen
              }, "Verbinden", context.isDarkMode ? white : black,
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

  ///Card design for showing devices found
  customDeviceFoundDesign(
      deviceName, deviceImage, voidcallback, index, clickedDevice) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              voidcallback();
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 46,
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: containerBlack,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(70),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 70,
                        ),
                        Expanded(
                            child: Text("$deviceName",
                                style: fontStyling(
                                  20.0,
                                  FontWeight.w600,
                                  white,
                                ))),
                        if (clickedDevice.toString() == index.toString())
                          SvgPicture.asset(
                            'assets/images/devieselecttick.svg',
                            height: 24,
                          ),
                        if (clickedDevice.toString() != index.toString())
                          SvgPicture.asset(
                            'assets/images/deviceselectioncircle.svg',
                            height: 24,
                          ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Image.asset(
                "$deviceImage",
                height: 91,
                width: 90,
              ))
        ],
      ),
    );
  }
}
