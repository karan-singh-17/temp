import 'package:flutter/material.dart';
import 'package:moe/domain/Models/SeekBarModel.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/domain/helper/UtilHelper.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../domain/helper/Colors.dart';

class SeekbarWidget extends StatefulWidget {
  final SeekbarModel viewModel;
  final double value;
  final ValueChanged<double> onChanged;

  const SeekbarWidget({
    super.key,
    required this.viewModel,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SeekbarWidget> createState() => _SeekbarWidgetState();
}

class _SeekbarWidgetState extends State<SeekbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Center(
          child: SleekCircularSlider(
            onChange: widget.onChanged,
            innerWidget: (double value) {
              return Container(
                  margin: const EdgeInsets.only(left: 220),
                  child: Center(
                      child: RotatedBox(
                          quarterTurns: 2,
                          child: Text("${value.round()}\u02DA",
                              style: fontStyling(
                                  30.0,
                                  FontWeight.w500,
                                  context.isDarkMode
                                      ? primaryLightBackgroundColor
                                      : black)))));
            },
            appearance: widget.viewModel.appearance,
            min: widget.viewModel.min,
            max: widget.viewModel.max,
            initialValue: widget.value,
          ),
        ),
      ),
    );
  }
}
