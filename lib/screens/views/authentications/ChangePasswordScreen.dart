import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/profileandsettingscreen/UserProfileScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var _obscureText = true;
  var _obscureTextSecond = true;
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
                      ///Navigate to user profile screen
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfileScreen(),
                          ));
                    }, context),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kennwort ändern',
                            style: fontStyling(30.0, FontWeight.w700,
                                context.isDarkMode ? white : black),
                          ),
                          const SizedBox(
                            height: 43,
                          ),
                          Text(
                            "Passwort",
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
                                    obscureText: _obscureText,
                                    style: fontStyling(14.0, FontWeight.w300,
                                        context.isDarkMode ? white : black),
                                    decoration: InputDecoration(
                                        hintText: "Geben Sie Ihr Passwort ein",
                                        hintStyle: fontStyling(
                                            14.0, FontWeight.w300, grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _obscureText = !_obscureText;
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      _obscureText
                                          ? "assets/images/lightmodepasswordhide.svg"
                                          : "assets/images/lightmodepassowrdrevel.svg",
                                      color: context.isDarkMode ? white : black,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Bestätige das Passwort",
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
                                    obscureText: _obscureTextSecond,
                                    style: fontStyling(14.0, FontWeight.w300,
                                        context.isDarkMode ? white : black),
                                    decoration: InputDecoration(
                                        hintText:
                                            "Geben Sie das Bestätigungspasswort ein",
                                        hintStyle: fontStyling(
                                            14.0, FontWeight.w300, grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _obscureTextSecond = !_obscureTextSecond;
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      _obscureTextSecond
                                          ? "assets/images/lightmodepasswordhide.svg"
                                          : "assets/images/lightmodepassowrdrevel.svg",
                                      color: context.isDarkMode ? white : black,
                                    ))
                              ],
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
                  solidColorMainUiButton(() {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileScreen(),
                        ));
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
