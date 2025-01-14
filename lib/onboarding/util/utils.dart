import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryLightBackgroundColor = const Color(0xffF1EFE5);
Color black = const Color(0xff3D3D3E);
Color white = const Color(0xffF1EFE5);
Color grey = const Color(0xff898989);
Color containerBlack = const Color(0xff2C2C2C);
Color greyForSettingRound = const Color(0xffD9D9D9);

class TextColor {
  var light = const Color(0xff3D3D3E);
  var dark = const Color(0xffE7E3CF);
}

fontStyling(textSize, FontWeight fontWeight, Color fontColor) {
  return GoogleFonts.roboto(
      textStyle: TextStyle(
          fontSize: textSize, fontWeight: fontWeight, color: fontColor));
}

extension DarkMode on BuildContext {
  /// checks is dark mode currently enabled or not
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

  Color get txColor => isDarkMode ? TextColor().dark : TextColor().light;
}

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

borderLandingUiButton(
    VoidCallback voidCallback, var text, Color borderColor, Color textColor) {
  return GestureDetector(
    onTap: () {
      voidCallback();
    },
    child: Container(
      //width: double.infinity,
      height: 45,
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
            fontSize: 12.0, color: textColor, fontWeight: FontWeight.w700),
        // style: fontStyling(14.0, FontWeight.w600, textColor),
      )),
    ),
  );
}
