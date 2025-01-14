import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moe/domain/helper/Colors.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/domain/helper/UiHelper.dart';
import 'package:moe/screens/views/authentications/SignUpScreen.dart';

import '../../../domain/helper/UtilHelper.dart';
import '../dashboard/DashboardScreen.dart';
import '../dashboard/dashboard_multiple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        SystemNavigator.pop();

        ///close the app on system back
      },
      child: Scaffold(
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
                          'Log In',
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
                              hintStyle:
                                  fontStyling(14.0, FontWeight.w300, grey),
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
                                obscureText: true,
                                style: fontStyling(14.0, FontWeight.w300,
                                    context.isDarkMode ? white : black),
                                decoration: InputDecoration(
                                    hintText: "Geben Sie Ihr Passwort ein",
                                    hintStyle: fontStyling(
                                        14.0, FontWeight.w300, grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Text(
                              "Vergessen",
                              style: fontStyling(14.0, FontWeight.w300,
                                  context.isDarkMode ? white : black),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sie haben kein Konto? ',
                            style: fontStyling(14.0, FontWeight.w400,
                                context.isDarkMode ? white : grey),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpScreen(),
                                    ));

                                ///Navigate to the signup screen
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

                    ///Navigate to dashboard screen
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
      ),
    );
  }
}
