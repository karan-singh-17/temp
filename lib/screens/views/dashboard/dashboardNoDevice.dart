import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/domain/classes/utils.dart';

class NoDeviceScreen extends StatefulWidget {
  const NoDeviceScreen({super.key});

  @override
  State<NoDeviceScreen> createState() => _NoDeviceScreenState();
}

class _NoDeviceScreenState extends State<NoDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeProperties themeProperties = ThemeProperties(context: context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: themeProperties.size.height * 0.1,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "DEIN MOE",
            style: GoogleFonts.robotoFlex(
                textStyle: TextStyle(
                    fontSize: 26,
                    color: themeProperties.txColor,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        backgroundColor: themeProperties.scColor,
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    color: themeProperties.txColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: themeProperties.scColor,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: themeProperties.size.width * 0.35,
              height: themeProperties.size.height * 0.25,
              child: SvgPicture.asset(
                'assets/svg/no-connection.svg',
                color: themeProperties.txColor.withOpacity(0.25),
              ),
            ),
            Text(
              "KEINE GERÄTE ANGEMELDET",
              style: GoogleFonts.robotoFlex(
                  color: themeProperties.txColor.withOpacity(0.3),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
          child: BottomAppBar(
            padding:
                EdgeInsets.only(top: 10, bottom: Platform.isAndroid ? 1 : 3),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 15,
            color: Colors.transparent,
            shadowColor: const Color.fromARGB(54, 0, 0, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: themeProperties.scColorInv),
                child: const Row(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
