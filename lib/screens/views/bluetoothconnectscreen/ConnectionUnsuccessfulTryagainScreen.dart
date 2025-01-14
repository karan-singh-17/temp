import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';

class ConnectionUnsuccessfulTryagainScreen extends StatefulWidget {
  const ConnectionUnsuccessfulTryagainScreen({super.key});

  @override
  State<ConnectionUnsuccessfulTryagainScreen> createState() =>
      _ConnectionUnsuccessfulTryagainScreenState();
}

class _ConnectionUnsuccessfulTryagainScreenState
    extends State<ConnectionUnsuccessfulTryagainScreen> {
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
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: SvgPicture.asset(context.isDarkMode
                  ? "assets/images/deviceconnectionunsuccessiconfordarkmode.svg"
                  : "assets/images/deviceconnectionunsuccessiconforlightmode.svg"),
            ),
            const SizedBox(
              height: 40,
            ),
            Text("Gerät nicht verbunden",
                style: fontStyling(
                  25.0,
                  FontWeight.w700,
                  context.isDarkMode ? white : black,
                )),
            const SizedBox(
              height: 40,
            ),
            solidColorMainUiButton(
                () async {},
                "Erneut versuchen",
                context.isDarkMode ? white : black,
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
