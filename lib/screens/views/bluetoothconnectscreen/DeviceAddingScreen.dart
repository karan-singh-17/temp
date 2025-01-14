import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/domain/helper/UiHelper.dart';
import 'package:moe/onboarding/app/view/app.dart';
import 'package:moe/screens/views/profileandsettingscreen/ProfileSettingScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UtilHelper.dart';

class DeviceAddingScreen extends StatefulWidget {
  const DeviceAddingScreen({super.key});

  @override
  State<DeviceAddingScreen> createState() => _DeviceAddingScreenState();
}

class _DeviceAddingScreenState extends State<DeviceAddingScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Profilesettingscreen(),

            ///Navigate to setting screen on system back
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 40,
              ),
              SvgPicture.asset(context.isDarkMode
                  ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                  : "assets/images/deviceaddscreenappiconforlightmode.svg"),
              Expanded(
                  child: Image.asset(
                "assets/images/invertoraloneimage.png",
                height: 185,
                width: 235,
              )),
              Text('schalte das Gerät ein',
                  style: fontStyling(
                    25.0,
                    FontWeight.w700,
                    context.isDarkMode ? primaryLightBackgroundColor : black,
                  )),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Schalten Sie Ihr Batteriegerät ein, indem \nSie  die Taste darauf drücken.',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: grey,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              solidColorMainUiButton(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const App(),
                    ));

                ///Navigate to the bluetooth searching screen
              }, "Verbinde meinen Akku", context.isDarkMode ? white : black,
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
