import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    //brightness: Brightness.light,
    colorScheme:
        ColorScheme.fromSeed(seedColor: const Color.fromRGBO(241, 239, 229, 1)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(241, 239, 229, 1),
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(241, 239, 229, 1),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Color.fromRGBO(61, 61, 62, 1),
        fontWeight: FontWeight.w500,
      ),
      alignLabelWithHint: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(61, 61, 62, 1),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(61, 61, 62, 1),
        ),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(61, 61, 62, 1),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    //brightness: Brightness.dark,
    colorScheme:
        ColorScheme.fromSeed(seedColor: const Color.fromRGBO(61, 61, 62, 1)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(61, 61, 62, 1),
      iconTheme: IconThemeData(
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
    ),

    iconTheme: const IconThemeData(
      color: Color.fromRGBO(241, 239, 229, 1),
    ),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
            iconColor: WidgetStatePropertyAll(
      Color.fromRGBO(241, 239, 229, 1),
    ))),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Color.fromRGBO(241, 239, 229, 1),
        fontWeight: FontWeight.w500,
      ),
      alignLabelWithHint: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(241, 239, 229, 1)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(241, 239, 229, 1)),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(241, 239, 229, 1)),
      ),
    ),
    cardColor: const Color.fromRGBO(241, 239, 229, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(61, 61, 62, 1),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      displayLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      bodySmall: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      displayMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      displaySmall: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Roboto',
        color: Color.fromRGBO(241, 239, 229, 1),
      ),
    ),
  );

  static BoxDecoration lightContainerDecoration = BoxDecoration(
    color: const Color.fromRGBO(61, 61, 62, 1),
    borderRadius: BorderRadius.circular(90),
  );

  static BoxDecoration darkContainerDecoration = BoxDecoration(
    color: const Color.fromRGBO(241, 239, 229, 1),
    borderRadius: BorderRadius.circular(90),
  );

  static Color lightSvgColor = const Color.fromRGBO(241, 239, 229, 1);
  static Color darkSvgColor = const Color.fromRGBO(61, 61, 62, 1);
}

ThemeClass _themeClass = ThemeClass();
