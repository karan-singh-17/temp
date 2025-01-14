import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Reusable font styling
fontStyling(textSize, FontWeight fontWeight, Color fontColor) {
  return GoogleFonts.roboto(
      textStyle: TextStyle(
          fontSize: textSize, fontWeight: fontWeight, color: fontColor));
}