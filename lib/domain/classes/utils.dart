import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextColor {
  var light = const Color(0xff3D3D3E);
  var dark = const Color(0xffE7E3CF);
}

class ScaffoldColor {
  var light = const Color(0xffE7E3CF);
  var dark = const Color(0xff3D3D3E);
}

class DeviceLocation {
  double lat;
  double long;
  DeviceLocation({required this.lat, required this.long});
}

class ThemeProperties {
  BuildContext context;

  ThemeProperties({required this.context});

  Brightness get brightness => MediaQuery.of(context).platformBrightness;
  bool get isDarkMode => brightness == Brightness.dark;
  Color get scColor =>
      isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
  Color get scColorInv =>
      isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
  Color get txColor => isDarkMode ? TextColor().dark : TextColor().light;
  Color get txColorInv => isDarkMode ? TextColor().light : TextColor().dark;
  Size get size => MediaQuery.of(context).size;
}

Color containerBlack = const Color(0xff2C2C2C);
Color black = const Color(0xff3D3D3E);
Color primaryLightBackgroundColor = const Color(0xffF1EFE5);
Color white = const Color(0xffE7E3CF);
fontStyling(textSize, FontWeight fontWeight, Color fontColor) {
  return GoogleFonts.roboto(
      textStyle: TextStyle(
          fontSize: textSize, fontWeight: fontWeight, color: fontColor));
}
