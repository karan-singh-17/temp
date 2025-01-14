import 'package:flutter/material.dart';
import 'package:moe/data/responses/forecastRes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/domain/classes/utils.dart';

class ForecastView extends StatefulWidget {
  final List forecast;
  final List forecastDummy = [
    ForecastRes(
        pvEstimate: 2.652,
        periodEnd: DateTime(2024, 6, 24, 08, 30),
        period: const Duration(minutes: 30)),
    ForecastRes(
        pvEstimate: 2.652,
        periodEnd: DateTime(2024, 6, 24, 08, 30),
        period: const Duration(minutes: 30)),
    ForecastRes(
        pvEstimate: 2.652,
        periodEnd: DateTime(2024, 6, 24, 08, 30),
        period: const Duration(minutes: 30)),
    ForecastRes(
        pvEstimate: 2.652,
        periodEnd: DateTime(2024, 6, 24, 08, 30),
        period: const Duration(minutes: 30))
  ];
  ForecastView({super.key, required this.forecast});

  @override
  State<ForecastView> createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var scColorInv = isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    var txColorInv = isDarkMode ? TextColor().light : TextColor().dark;
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
        height: double.infinity,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PV-Vorhersage",
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
              ListView.builder(
                  itemBuilder: (context, index) => Container(
                        child: const Column(),
                      )),
            ]),
      ),
    );
  }
}
