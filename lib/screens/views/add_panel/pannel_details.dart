import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/data/responses/forecastRes.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../../domain/classes/utils.dart';
import '../../../domain/providers/forecast_provider.dart';

class PannelDetail extends StatefulWidget {
  const PannelDetail({super.key});

  @override
  State<PannelDetail> createState() => _PannelDetailState();
}

class _PannelDetailState extends State<PannelDetail> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var scColorInv = isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    var txColorInv = isDarkMode ? TextColor().light : TextColor().dark;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: scColor,
      appBar: AppBar(
        backgroundColor: scColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: txColor),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle_outlined, color: txColor, size: 33),
          ),
          SizedBox(width: size.width * 0.0),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ÜBERSICHT",
                style: GoogleFonts.roboto(
                  color: txColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HEUTE",
                      style: GoogleFonts.roboto(
                        color: txColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      height: size.height * 0.2,
                      width: size.width,
                      padding:
                          const EdgeInsets.only(right: 6, bottom: 6, top: 6),
                      decoration: BoxDecoration(
                        color: scColorInv,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Consumer<ForecastProvider>(
                        builder: (context, forecastProvider, child) {
                          final forecasts = forecastProvider.forecasts;

                          if (forecasts.isEmpty) {
                            return Center(
                              child: Text(
                                "No Data Available",
                                style: GoogleFonts.roboto(color: txColorInv),
                              ),
                            );
                          }

                          return SfCartesianChart(
                            backgroundColor: scColorInv,
                            enableAxisAnimation: true,
                            primaryXAxis: DateTimeAxis(
                              intervalType: DateTimeIntervalType.hours,
                              interval: 1,
                              dateFormat: DateFormat
                                  .Hm(), // Format to display hours:minutes
                              borderColor: scColorInv,
                              axisLabelFormatter: (axisLabelRenderArgs) {
                                return ChartAxisLabel(
                                    axisLabelRenderArgs.text,
                                    GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            color: txColorInv, fontSize: 8)));
                              },
                              labelStyle: TextStyle(color: txColorInv),
                              majorGridLines: const MajorGridLines(width: 0),
                              axisLine: AxisLine(width: 2, color: txColorInv),
                              majorTickLines: const MajorTickLines(size: 0),
                            ),
                            primaryYAxis: NumericAxis(
                              axisLabelFormatter:
                                  (AxisLabelRenderDetails details) {
                                return ChartAxisLabel(
                                    "${details.text}W",
                                    GoogleFonts.roboto(
                                        textStyle:
                                            TextStyle(color: txColorInv)));
                              },
                              majorGridLines: const MajorGridLines(width: 0),
                              axisLine: AxisLine(width: 2, color: txColorInv),
                              majorTickLines: const MajorTickLines(size: 0),
                            ),
                            plotAreaBorderWidth: 0,
                            legend: const Legend(isVisible: false),
                            tooltipBehavior: TooltipBehavior(
                                enable: true, color: Colors.redAccent),
                            series: [
                              SplineSeries<ForecastRes, DateTime>(
                                color: txColorInv,
                                dataSource: forecastProvider.forecasts,
                                xValueMapper: (ForecastRes forecast, _) =>
                                    DateTime.parse(
                                        forecast.periodEnd.toString()),
                                yValueMapper: (ForecastRes forecast, _) =>
                                    forecast.pvEstimate,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: false,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
