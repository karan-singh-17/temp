import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';

import '../../../domain/classes/utils.dart';
import '../../../domain/helper/UiHelper.dart';
import '../dashboard/dashboard_multiple.dart';
import '../profileandsettingscreen/ProfileSettingScreen.dart';

class History_graph extends StatefulWidget {
  const History_graph({super.key});

  @override
  State<History_graph> createState() => _History_graphState();
}

class _History_graphState extends State<History_graph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 20,
            ),

            ///top header
            topNavigation(() {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardMultiple(),

                    ///Navigate to dashboard screen
                  ));
            }, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profilesettingscreen(),

                    ///Navigate to setting screen
                  ));
            }, context),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ÜBERSICHT',
                      style: fontStyling(30.0, FontWeight.w700,
                          context.isDarkMode ? white : black),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            dailyOverViewCardDesign(),

                            ///Daily overview card design
                            const SizedBox(
                              height: 20,
                            ),
                            sevendaysOverviewCardDesign(),

                            ///Seven days overview Card design
                            const SizedBox(
                              height: 20,
                            ),
                            lastThreeMonthcOverviewCardDesign(),

                            ///Last three months overview card design
                            const SizedBox(
                              height: 20,
                            ),
                            monthlyOverviewCardDesign(),

                            ///Monthly overview card design
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Daily overview card design
  dailyOverViewCardDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HEUTE',
          style: fontStyling(
              15.0, FontWeight.w700, context.isDarkMode ? white : black),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          height: 160,
          decoration: BoxDecoration(
              color: containerBlack, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 1),
                          FlSpot(2, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 2.5),
                          FlSpot(8, 4),
                          FlSpot(9, 4),
                          FlSpot(10, 3),
                          FlSpot(12, 4),
                          FlSpot(14, 2),
                          FlSpot(16, 5),
                          FlSpot(19, 3),
                          FlSpot(24, 3),
                        ],
                        isCurved: true,
                        dotData: const FlDotData(show: false),
                        color: white,
                        barWidth: 1,
                        aboveBarData: BarAreaData(
                          show: false,
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            String getFormattedTime(double value) {
                              int hour = value.toInt();
                              return '$hour:00';
                            }

                            return Text(
                              getFormattedTime(value),
                              style: fontStyling(8.0, FontWeight.w700, white),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: false), // Hide right titles
                      ),
                      topTitles: const AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: false), // Hide top titles
                      ),
                    ),
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Colors.white),
                        // Show left border
                        bottom: BorderSide(color: Colors.white),
                        // Show bottom border
                        right: BorderSide.none,
                        // Hide right border
                        top: BorderSide.none, // Hide top border
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  ///Seven days overview Card design
  sevendaysOverviewCardDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LETZTEN 7 TAGE',
          style: fontStyling(
              15.0, FontWeight.w700, context.isDarkMode ? white : black),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
              color: containerBlack, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide.none,
                      ),
                    ),
                    groupsSpace: 10,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 20),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                              toY: 12, fromY: 0, color: white, width: 20),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                              toY: 8, fromY: 0, color: white, width: 20),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                              toY: 14, fromY: 0, color: white, width: 20),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 20),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(
                              toY: 16, fromY: 0, color: white, width: 20),
                        ],
                      ),
                      BarChartGroupData(
                        x: 6,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 20),
                        ],
                      ),
                    ],
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const days = [
                              'M',
                              'DI',
                              'MI',
                              'DO',
                              'FR',
                              'SA',
                              'SO'
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                days[value.toInt()],
                                style: fontStyling(8.0, FontWeight.w700, white),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///Last three months overview card design
  lastThreeMonthcOverviewCardDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LETZTEN 3 MONATE',
          style: fontStyling(
              15.0, FontWeight.w700, context.isDarkMode ? white : black),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              color: containerBlack, borderRadius: BorderRadius.circular(20)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ],
    );
  }

  ///Monthly overview card design
  monthlyOverviewCardDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AKTUELLES JAHR',
          style: fontStyling(
              15.0, FontWeight.w700, context.isDarkMode ? white : black),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.only(bottom: 10, top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
              color: containerBlack, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide.none,
                      ),
                    ),
                    groupsSpace: 10,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 6,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 7,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 8,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 9,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 10,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                      BarChartGroupData(
                        x: 11,
                        barRods: [
                          BarChartRodData(
                              toY: 10, fromY: 0, color: white, width: 15),
                        ],
                      ),
                    ],
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const months = [
                              'J',
                              'F',
                              'MZ',
                              'A',
                              'MI',
                              'JI',
                              'JY',
                              'A',
                              'S',
                              'O',
                              'N',
                              'D'
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                months[value.toInt()],
                                style: fontStyling(8.0, FontWeight.w700, white),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}