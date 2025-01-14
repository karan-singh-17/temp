import 'dart:ui';

import 'package:sleek_circular_slider/sleek_circular_slider.dart';

///Seekbar model class
class SeekbarModel {
  final List<Color> pageColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double value;
  final InnerWidget? innerWidget;

  SeekbarModel(
      {required this.pageColors,
        required this.appearance,
        this.min = 0,
        this.max = 120,
        this.value = 50,
        this.innerWidget});
}