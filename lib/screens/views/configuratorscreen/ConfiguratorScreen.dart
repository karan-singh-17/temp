import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/Models/SeekBarModel.dart';
import 'package:moe/domain/helper/Database_Helper(local).dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/screens/views/configuratorscreen/seekbarComponent/SeekBarWidget.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../domain/helper/Colors.dart';
import '../../../domain/helper/UiHelper.dart';
import '../../../domain/helper/UtilHelper.dart';
import '../profileandsettingscreen/ProfileSettingScreen.dart';

///getSlider for giving style to seekbar
getSlider(mode) {
  final customWidth09 =
      CustomSliderWidths(trackWidth: 1, progressBarWidth: 1, handlerSize: 10);

  final customColors09 = CustomSliderColors(
    dotColor: mode ? black : primaryLightBackgroundColor,
    trackColor: mode ? black : primaryLightBackgroundColor,
    progressBarColors: [
      mode ? black : primaryLightBackgroundColor,
      mode ? black : primaryLightBackgroundColor,
      mode ? black : primaryLightBackgroundColor
    ],
  );

  final CircularSliderAppearance appearance09 = CircularSliderAppearance(
    customWidths: customWidth09,
    customColors: customColors09,
    startAngle: 300,
    angleRange: 110,
    size: 333.0,
    counterClockwise: false,
  );

  return appearance09;
}

class ConfiguratorScreen extends StatefulWidget {
  Map<String, dynamic> pannel;
  ConfiguratorScreen({super.key, required this.pannel});

  @override
  State<ConfiguratorScreen> createState() => _ConfiguratorScreenState();
}

class _ConfiguratorScreenState extends State<ConfiguratorScreen> {
  ///Declaring variable
  bool light = true;
  double sliderValue = 0.0;
  double org_val = 0.0;
  //double sliderValue = widget.pannel['angle'];
  /// Initialize slider value
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderValue = widget.pannel['angle'];
    org_val = sliderValue;
  }

  @override
  Widget build(BuildContext context) {
    ///seekBar view model
    final viewModel = SeekbarModel(
      appearance: getSlider(!context.isDarkMode),
      value: sliderValue, // Use sliderValue here
      pageColors: [black, black, black, black],
    );

    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 20,
            ),
            topNavigation(() {
              Navigator.pop(context);
            }, () {}, context),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "AKTUELLE \nEINSTELLUNG",
                                  style: fontStyling(12.0, FontWeight.w600,
                                      context.isDarkMode ? white : black),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  " OPTIMALE\nEINSTELLUNG",
                                  style: fontStyling(12.0, FontWeight.w600,
                                      context.isDarkMode ? white : black),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${org_val.roundToDouble().toStringAsFixed(1)}",
                                  style: fontStyling(24.0, FontWeight.w700,
                                      context.isDarkMode ? white : black),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "30°",
                                  style: fontStyling(24.0, FontWeight.w700,
                                      context.isDarkMode ? white : black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 480,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            child: Image.asset(
                              "assets/images/new_pannel.png",
                              height: 510,
                              width: 210,
                            ),
                          ),
                          Positioned(
                            left: 30,
                            bottom: 0,
                            top: 0,
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: SeekbarWidget(
                                ///Seekbar widget
                                viewModel: viewModel,
                                value: sliderValue,

                                /// Pass sliderValue here
                                onChanged: (value) {
                                  setState(() {
                                    sliderValue = value.roundToDouble();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: solidColorMainUiButton(() async {
                        try {
                          int result = await DatabaseHelper().updateSystemAngle(
                              widget.pannel['id'], sliderValue);
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Pannel angle updated to $sliderValue!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('System not found.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Error updating system angle: $error'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }, "Speichern", context.isDarkMode ? white : black,
                          context.isDarkMode ? black : white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  topNavigation(VoidCallback voidcallbackfirst, VoidCallback voidcallbacksecond,
      BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
}
