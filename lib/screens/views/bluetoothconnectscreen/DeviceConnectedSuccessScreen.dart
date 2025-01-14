import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/addmodulescreen/AddModuleScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UtilHelper.dart';

class DeviceConnectedSuccessScreen extends StatefulWidget {
  const DeviceConnectedSuccessScreen({super.key});

  @override
  State<DeviceConnectedSuccessScreen> createState() =>
      _DeviceConnectedSuccessScreenState();
}

class _DeviceConnectedSuccessScreenState
    extends State<DeviceConnectedSuccessScreen> {
  ///initState method
  @override
  void initState() {
    // TODO: implement initState
    navigateToProfilesettingscreen();
  }

  ///Temporary for showing screen design
  navigateToProfilesettingscreen() {
    ///Navigate to add Module screen after 4 seconds
    Timer(const Duration(seconds: 3), () async {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (builder) => const AddModuleScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              child: SvgPicture.asset(context.isDarkMode
                  ? "assets/images/deviceconnectedtickfordarkmode.svg"
                  : "assets/images/deviceconnectedtickforlightmode.svg"),
            ),
            Text(
              "Erfolgreich Gerät verbunden",
              style: fontStyling(
                25.0,
                FontWeight.w700,
                context.isDarkMode ? white : black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
