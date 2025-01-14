import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/authentications/LoginScreen.dart';
import 'package:moe/screens/views/dashboard/DashboardScreen.dart';

import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';
import '../dashboard/dashboard_multiple.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ///Declaring variables
  var _obscureText = true;
  var _obscureTextSecond = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      height: 100,
                    ),
                    Row(children: [
                      Text(
                        'Registration',
                        style: fontStyling(30.0, FontWeight.w700,
                            context.isDarkMode ? white : black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      context.isDarkMode
                          ? SvgPicture.asset(
                              "assets/images/darkmodeprofileicon.svg")
                          : SvgPicture.asset(
                              "assets/images/lightmodeprofileicon.svg")
                    ]),
                    const SizedBox(
                      height: 40,
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
                                  color: context.isDarkMode ? white : black,
                                  width: 1))),
                      child: TextField(
                        cursorColor: context.isDarkMode ? white : black,
                        style: fontStyling(14.0, FontWeight.w300,
                            context.isDarkMode ? white : black),
                        decoration: InputDecoration(
                            hintText: "Gib deinen Namen ein",
                            hintStyle: fontStyling(14.0, FontWeight.w300, grey),
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
                                  color: context.isDarkMode ? white : black,
                                  width: 1))),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: context.isDarkMode ? white : black,
                              style: fontStyling(14.0, FontWeight.w300,
                                  context.isDarkMode ? white : black),
                              decoration: InputDecoration(
                                  hintText: "Geben Sie Ihre Telefonnummer ein",
                                  hintStyle:
                                      fontStyling(14.0, FontWeight.w300, grey),
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
                                  color: context.isDarkMode ? white : black,
                                  width: 1))),
                      child: TextField(
                        cursorColor: context.isDarkMode ? white : black,
                        style: fontStyling(14.0, FontWeight.w300,
                            context.isDarkMode ? white : black),
                        decoration: InputDecoration(
                            hintText: "Geben sie ihre E-Mail Adresse ein",
                            hintStyle: fontStyling(14.0, FontWeight.w300, grey),
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
                                  color: context.isDarkMode ? white : black,
                                  width: 1))),
                      child: TextField(
                        cursorColor: context.isDarkMode ? white : black,
                        style: fontStyling(14.0, FontWeight.w300,
                            context.isDarkMode ? white : black),
                        decoration: InputDecoration(
                            hintText: "Geben Sie Ihr Geschlecht ein",
                            hintStyle: fontStyling(14.0, FontWeight.w300, grey),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                                  color: context.isDarkMode ? white : black,
                                  width: 1))),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: context.isDarkMode ? white : black,
                              obscureText: _obscureText,
                              style: fontStyling(14.0, FontWeight.w300,
                                  context.isDarkMode ? white : black),
                              decoration: InputDecoration(
                                  hintText: "Geben Sie Ihr Passwort ein",
                                  hintStyle:
                                      fontStyling(14.0, FontWeight.w300, grey),
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
                                  color: context.isDarkMode ? white : black,
                                  width: 1))),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: context.isDarkMode ? white : black,
                              obscureText: _obscureTextSecond,
                              style: fontStyling(14.0, FontWeight.w300,
                                  context.isDarkMode ? white : black),
                              decoration: InputDecoration(
                                  hintText:
                                      "Geben Sie das Bestätigungspasswort ein",
                                  hintStyle:
                                      fontStyling(14.0, FontWeight.w300, grey),
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
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sie haben bereits ein Konto? ',
                          style: fontStyling(14.0, FontWeight.w400,
                              context.isDarkMode ? white : grey),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));

                              ///Navigate to the Login screen
                            },
                            child: Text(
                              'Anmelden',
                              style: fontStyling(14.0, FontWeight.w400,
                                  context.isDarkMode ? white : black),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                solidColorMainUiButton(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardMultiple(),
                      ));

                  ///Navigate to the dashboard screen
                }, "Anmeldung", context.isDarkMode ? white : black,
                    context.isDarkMode ? black : white),
                const SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
