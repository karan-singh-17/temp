import 'package:flutter/material.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/authentications/ChangePasswordScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';
import 'ProfileSettingScreen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),

                    ///top header
                    topNavigationWithoutprofileIcon(() {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Profilesettingscreen(),
                          ));

                      ///Navigate to setting screen
                    }, context),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Benutzerprofil',
                            style: fontStyling(30.0, FontWeight.w700,
                                context.isDarkMode ? white : black),
                          ),
                          const SizedBox(
                            height: 43,
                          ),
                          Text(
                            "Name",
                            style: fontStyling(14.0, FontWeight.w600,
                                context.isDarkMode ? white : black),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color:
                                            context.isDarkMode ? white : black,
                                        width: 1))),
                            child: TextField(
                              cursorColor: context.isDarkMode ? white : black,
                              style: fontStyling(14.0, FontWeight.w300,
                                  context.isDarkMode ? white : black),
                              decoration: InputDecoration(
                                  hintText: "Gib deinen Namen ein",
                                  hintStyle:
                                      fontStyling(14.0, FontWeight.w300, grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Telefonnummer",
                            style: fontStyling(14.0, FontWeight.w600,
                                context.isDarkMode ? white : black),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color:
                                            context.isDarkMode ? white : black,
                                        width: 1))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    cursorColor:
                                        context.isDarkMode ? white : black,
                                    style: fontStyling(14.0, FontWeight.w300,
                                        context.isDarkMode ? white : black),
                                    decoration: InputDecoration(
                                        hintText:
                                            "Geben Sie Ihre Telefonnummer ein",
                                        hintStyle: fontStyling(
                                            14.0, FontWeight.w300, grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Deine E-Mail",
                            style: fontStyling(14.0, FontWeight.w600,
                                context.isDarkMode ? white : black),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color:
                                            context.isDarkMode ? white : black,
                                        width: 1))),
                            child: TextField(
                              cursorColor: context.isDarkMode ? white : black,
                              style: fontStyling(14.0, FontWeight.w300,
                                  context.isDarkMode ? white : black),
                              decoration: InputDecoration(
                                  hintText: "Geben sie ihre E-Mail Adresse ein",
                                  hintStyle:
                                      fontStyling(14.0, FontWeight.w300, grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Geschlecht",
                            style: fontStyling(14.0, FontWeight.w600,
                                context.isDarkMode ? white : black),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color:
                                            context.isDarkMode ? white : black,
                                        width: 1))),
                            child: TextField(
                              cursorColor: context.isDarkMode ? white : black,
                              style: fontStyling(14.0, FontWeight.w300,
                                  context.isDarkMode ? white : black),
                              decoration: InputDecoration(
                                  hintText: "Geben Sie Ihr Geschlecht ein",
                                  hintStyle:
                                      fontStyling(14.0, FontWeight.w300, grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  borderMainUiButton(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ));

                    ///Navigate to change password screen
                  }, "Kennwort ändern", context.isDarkMode ? white : black,
                      context.isDarkMode ? white : black),
                  const SizedBox(
                    height: 20,
                  ),
                  solidColorMainUiButton(() {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Profilesettingscreen(),
                        ));

                    ///Navigate to setting screen
                  }, "Änderungen speichern", context.isDarkMode ? white : black,
                      context.isDarkMode ? black : white),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
