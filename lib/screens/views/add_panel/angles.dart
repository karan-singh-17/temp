import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/domain/providers/add_provider.dart';
import 'package:moe/screens/views/add_panel/capacity.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:moe/domain/classes/utils.dart';

class Angles extends StatefulWidget {
  const Angles({super.key});

  @override
  State<Angles> createState() => _AnglesState();
}

class _AnglesState extends State<Angles> {
  int segmentNumber = 1;
  double _azimuth = 0.0;
  double azimut = 0.0;
  double _tiltValue = 0.0;
  bool _isButtonHighlighted = false;
  bool checkValues(double azimuth, double tiltValue) {
    if (tiltValue.round() > 0.0) return true;
    return false;
  }

  void flipSegmentNumber(int newSegmentNumber) {
    setState(() {
      segmentNumber = newSegmentNumber;
    });
  }

  void onMarkerDragEnd(double newValue) {
    // Snap the marker to the nearest 45-degree position
    double snappedValue = (newValue / 45).round() * 45.0;
    setState(() {
      _azimuth = snappedValue;
      azimut = _azimuth - 180;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AddProvider addProvider = Provider.of<AddProvider>(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var scColorInv = isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    var txColorInv = isDarkMode ? TextColor().light : TextColor().dark;
    CustomSegmentedController segmentedController = CustomSegmentedController();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: scColor,
      appBar: AppBar(
        toolbarHeight: size.height * 0.0912,
        backgroundColor: scColor,
        leading: IconButton(
          iconSize: 32,
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 28,
          ),
          color: txColor,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.all(4),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "HINZUFÜGEN",
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: txColor)),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            SizedBox(
              height: size.height * 0.15,
              child: _isButtonHighlighted
                  ? Text(
                "Neigung müssen größer als Null sein",
                textAlign: TextAlign.left,
                maxLines: 2,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Colors.red[600])),
              )
                  : Text(
                segmentNumber == 1
                    ? "Wohin zeigt"
                    : "Stellen Sie Ihre Winkel ein",
                textAlign: TextAlign.left,
                maxLines: 2,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                        color: txColor)),
              ),
            ),
            Center(
                child: tabSlider(
                    isDarkMode, txColorInv, txColor, segmentedController)),
            SizedBox(height: size.height * 0.034),
            Container(
              child: segmentNumber == 1
                  ? azimuthSlider(txColor, isDarkMode)
                  : tiltSlider(txColor, isDarkMode),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (checkValues(_azimuth, _tiltValue)) {
                    addProvider.setAzimuth(azimut);
                    addProvider.setTilt(_tiltValue);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const Capacity()));
                  } else {
                    // Highlight the button and show error message
                    setState(() {
                      _isButtonHighlighted = true;
                    });
                  }
                },
                child: NextButtonBar(
                    size: size,
                    isButtonHighlighted: _isButtonHighlighted,
                    scColorInv: scColorInv,
                    txColorInv: txColorInv),
              ),
            )
          ],
        ),
      ),
    );
  }

  CustomSlidingSegmentedControl<dynamic> tabSlider(
      bool isDarkMode,
      Color txColorInv,
      Color txColor,
      CustomSegmentedController<dynamic> segmentedController) {
    return CustomSlidingSegmentedControl(
      initialValue: 1,
      fixedWidth: 100,
      customSegmentSettings:
      CustomSegmentSettings(splashFactory: NoSplash.splashFactory),
      thumbDecoration: BoxDecoration(
          color: isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark,
          borderRadius: BorderRadius.circular(40)),
      decoration: BoxDecoration(
          color: isDarkMode
              ? const Color.fromARGB(255, 90, 90, 89)
              : const Color.fromARGB(255, 214, 210, 188),
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(40)),
      children: {
        1: Text(
          "Richtung",
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: segmentNumber == 1 ? txColorInv : txColor)),
        ),
        2: Text(
          "Neigung",
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: segmentNumber == 2 ? txColorInv : txColor)),
        ),
      },
      onValueChanged: (v) {
        flipSegmentNumber(v);
        setState(() {
          _isButtonHighlighted = false;
        });
      },
      controller: segmentedController,
    );
  }

  Expanded azimuthSlider(Color txColor, bool isDarkMode) {
    return Expanded(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 360,
            interval: 45,
            showLabels: false,
            axisLabelStyle: GaugeTextStyle(
                color: txColor, fontWeight: FontWeight.w800, fontSize: 12),
            startAngle: 270, // Start from the top (N)
            endAngle: 270, // End at the top (N) to make it a full circle
            minorTicksPerInterval: 25,
            minorTickStyle: const MinorTickStyle(thickness: 0.7),
            majorTickStyle: const MajorTickStyle(
              length: 10,
              thickness: 2,
              lengthUnit: GaugeSizeUnit.logicalPixel,
            ), // Remove minor ticks
            axisLineStyle: AxisLineStyle(
                thickness: 12,
                color: isDarkMode
                    ? const Color.fromARGB(255, 90, 90, 89)
                    : const Color.fromARGB(
                    255, 214, 210, 188) // Make the slider thinner
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: _azimuth,
                color: Colors.transparent,
                startWidth: 12,
                endWidth: 12,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _azimuth,
                markerType: MarkerType.circle,
                animationDuration: 20,
                enableAnimation: true,
                elevation: 4,
                overlayRadius: 0,
                animationType: AnimationType.ease,
                color: isDarkMode
                    ? const Color.fromARGB(255, 214, 210, 188)
                    : const Color(0xff4A4942),
                markerHeight: 30,
                markerWidth: 30,
                enableDragging: true,
                onValueChanged: (double newValue) {
                  setState(() {
                    _azimuth = newValue;

                    _isButtonHighlighted = false;
                  });
                },
                onValueChangeEnd: onMarkerDragEnd,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Container(
                  child: Text(
                    getDirectionLabel(_azimuth),
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: txColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                angle: 90,
                positionFactor: 0.0, // Move the annotation to the center
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded tiltSlider(Color txColor, bool isDarkMode) {
    return Expanded(
      child: Center(
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: -0.1,
              maximum: 90.1,
              interval: 30,
              showLabels: false,
              showTicks: false,
              axisLabelStyle: GaugeTextStyle(
                  color: txColor, fontWeight: FontWeight.w800, fontSize: 12),
              startAngle: 90, // Start from the left (W)
              endAngle: 270, // End at the right (E) to make it a semi-circle
              minorTicksPerInterval: 30,
              majorTickStyle: const MajorTickStyle(length: 10, thickness: 1.5),
              minorTickStyle:
              const MinorTickStyle(thickness: 0.75), // Remove minor ticks
              axisLineStyle: AxisLineStyle(
                  thickness: 6,
                  color: isDarkMode
                      ? const Color.fromARGB(255, 90, 90, 89)
                      : const Color.fromARGB(
                      255, 214, 210, 188) // Make the slider thinner
              ),
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: _tiltValue,
                  color: isDarkMode
                      ? const Color.fromARGB(255, 240, 233, 204)
                      : const Color(0xff4A4942),
                  startWidth: 6,
                  endWidth: 6,
                  // Rounded corners
                ),
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: _tiltValue,
                  markerType: MarkerType.circle,
                  animationDuration: 20,
                  enableAnimation: true,
                  elevation: 4,
                  overlayRadius: 0,
                  animationType: AnimationType.ease,
                  color: isDarkMode
                      ? const Color.fromARGB(255, 214, 210, 188)
                      : const Color(0xff4A4942),
                  markerHeight: 25,
                  markerWidth: 25,
                  enableDragging: true,
                  onValueChanged: (double newValue) {
                    setState(() {
                      _tiltValue = newValue;
                      _isButtonHighlighted = false;
                    });
                  },
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Container(
                    child: Text(
                      "${_tiltValue.toStringAsFixed(-0)}°",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: txColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.0, // Move the annotation to the center
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getDirectionLabel(double value) {
    if (value >= 337.5 || value < 22.5) {
      return 'S';
    } else if (value >= 22.5 && value < 67.5) {
      return 'SE';
    } else if (value >= 67.5 && value < 112.5) {
      return 'E';
    } else if (value >= 112.5 && value < 157.5) {
      return 'NE';
    } else if (value >= 157.5 && value < 202.5) {
      return 'N';
    } else if (value >= 202.5 && value < 247.5) {
      return 'NW';
    } else if (value >= 247.5 && value < 292.5) {
      return 'W';
    } else {
      return 'SW';
    }
  }
}

class NextButtonBar extends StatelessWidget {
  const NextButtonBar({
    super.key,
    required this.size,
    required bool isButtonHighlighted,
    required this.scColorInv,
    required this.txColorInv,
  }) : _isButtonHighlighted = isButtonHighlighted;

  final Size size;
  final bool _isButtonHighlighted;
  final Color scColorInv;
  final Color txColorInv;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.85,
      height: size.height * 0.062,
      decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(40),
          color: _isButtonHighlighted ? Colors.red[600] : scColorInv),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
          ),
          Text(
            "Nächste",
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    color: _isButtonHighlighted ? Colors.white : txColorInv,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ),
          SizedBox(
            width: size.width * 0.52,
          ),
          Container(
            height: size.height * 0.045,
            width: size.width * 0.097,
            decoration: BoxDecoration(
                border: Border.all(
                    style: BorderStyle.solid,
                    width: 3,
                    color: _isButtonHighlighted ? Colors.white : txColorInv),
                borderRadius: BorderRadius.circular(40)),
            child: Center(
              child: Icon(
                Icons.chevron_right_rounded,
                color: _isButtonHighlighted ? Colors.white : txColorInv,
              ),
            ),
          )
        ],
      ),
    );
  }
}
