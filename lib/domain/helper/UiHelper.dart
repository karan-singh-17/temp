import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';

import 'Colors.dart';

///Reusable button with single color
solidColorMainUiButton(
    VoidCallback voidCallback, var text, Color buttonColor, Color textColor) {
  return GestureDetector(
    onTap: () {
      voidCallback();
    },
    child: Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        color: buttonColor,
      ),
      child: Center(
          child: Text(
        text,
        style: GoogleFonts.roboto(
            fontSize: 16.0, color: textColor, fontWeight: FontWeight.w700),
        // style: fontStyling(14.0, FontWeight.w600, textColor),
      )),
    ),
  );
}

///Reusable button with border color
borderMainUiButton(
    VoidCallback voidCallback, var text, Color borderColor, Color textColor) {
  return GestureDetector(
    onTap: () {
      voidCallback();
    },
    child: Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          border: Border.all(
            color: borderColor,
            width: 1,
          )),
      child: Center(
          child: Text(
        text,
        style: GoogleFonts.roboto(
            fontSize: 16.0, color: textColor, fontWeight: FontWeight.w700),
        // style: fontStyling(14.0, FontWeight.w600, textColor),
      )),
    ),
  );
}

///Top header navigation bar
topNavigation(VoidCallback voidcallbackfirst, VoidCallback voidcallbacksecond,
    BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
    child: Row(
      children: [
        GestureDetector(
            onTap: () {
              voidcallbackfirst();
            },
            child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: SvgPicture.asset(
                  "assets/images/leftfacingarrow.svg",
                  color: context.isDarkMode ? white : black,
                ))),
        const Spacer(),
        // GestureDetector(
        //     onTap: () {
        //       voidcallbacksecond();
        //     },
        //     child: SvgPicture.asset(
        //       "assets/images/lightmodeprofileicon.svg",
        //       color: context.isDarkMode ? white : black,
        //     ))
      ],
    ),
  );
}

///Top header navigation bar without profile icon
topNavigationWithoutprofileIcon(voidcallbackfirst, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        GestureDetector(
            onTap: voidcallbackfirst,
            child: Container(
                height: 20,
                width: 20,
                color: Colors.transparent,
                child: SvgPicture.asset(
                  "assets/images/leftfacingarrow.svg",
                  color: context.isDarkMode ? white : black,
                ))),
      ],
    ),
  );
}
