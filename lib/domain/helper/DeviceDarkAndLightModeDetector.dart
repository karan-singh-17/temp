import 'dart:ui';
import 'package:flutter/widgets.dart';

extension DarkMode on BuildContext {
  /// checks is dark mode currently enabled or not
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}