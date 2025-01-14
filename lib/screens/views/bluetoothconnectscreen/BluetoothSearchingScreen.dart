import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/bluetoothconnectscreen/DeviceFoundScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UtilHelper.dart';

class BluetoothSearchingScreen extends StatefulWidget {
  const BluetoothSearchingScreen({super.key});

  @override
  State<BluetoothSearchingScreen> createState() =>
      _BluetoothSearchingScreenState();
}

class _BluetoothSearchingScreenState extends State<BluetoothSearchingScreen> {
  ///initState method
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToFoundDevice();
  }

  ///TEMPORARY for showing screen design
  navigateToFoundDevice() {
    ///Navigate to device found screen after 4 seconds
    Timer(const Duration(seconds: 4), () async {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (builder) => const DeviceFoundScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40,
            ),
            SvgPicture.asset(context.isDarkMode
                ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                : "assets/images/deviceaddscreenappiconforlightmode.svg"),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: greyForSettingRound, width: 1),
                          borderRadius: BorderRadius.circular(150)),
                      child: SvgPicture.asset(
                        "assets/images/bluetoothicon.svg",
                        height: 80,
                        width: 60,
                        color: context.isDarkMode ? white : black,
                      )),
                ],
              ),
            ),
            Text("Suche nach Geräten...",
                style: fontStyling(
                  25.0,
                  FontWeight.w700,
                  context.isDarkMode ? white : black,
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
              'es dauert ungefähr ein paar Sekunden',
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: grey,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
