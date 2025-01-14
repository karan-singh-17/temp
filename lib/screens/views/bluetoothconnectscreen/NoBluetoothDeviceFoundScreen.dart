import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/bluetoothconnectscreen/DeviceAddingScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';

class NoBluetoothDeviceFoundScreen extends StatefulWidget {
  const NoBluetoothDeviceFoundScreen({super.key});

  @override
  State<NoBluetoothDeviceFoundScreen> createState() =>
      _NoBluetoothDeviceFoundScreenState();
}

class _NoBluetoothDeviceFoundScreenState
    extends State<NoBluetoothDeviceFoundScreen> {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      decoration: BoxDecoration(
                          border: Border.all(color: grey, width: 0.4),
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
            Text("Kein Gerät gefunden",
                style: fontStyling(
                  25.0,
                  FontWeight.w700,
                  context.isDarkMode ? white : black,
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Leider konnten wir kein Bluetooth-Gerät finden. Bitte stellen Sie sicher, dass das Bluetooth Ihrer Hardware eingeschaltet ist.',
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: grey,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            solidColorMainUiButton(() async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeviceAddingScreen(),

                  ///Navigate to device adding screen
                ),
              );
            }, "erneut suchen", context.isDarkMode ? white : black,
                context.isDarkMode ? black : white),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
