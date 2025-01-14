import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:http/http.dart' as http;
import '../../../domain/classes/utils.dart';
import '../../../domain/helper/UiHelper.dart';
import '../dashboard/dashboard_multiple.dart';
import '../profileandsettingscreen/ProfileSettingScreen.dart';



class pannel_graph extends StatefulWidget {
  double lat;
  double long;
  String azi;
  String kap;
  String ang;

  pannel_graph({super.key , required this.lat ,required this.long ,required this.azi , required this.kap , required this.ang});

  @override
  State<pannel_graph> createState() => _pannel_graphState();
}

class _pannel_graphState extends State<pannel_graph> {
  late Future<Map<String, dynamic>> futureApiData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureApiData = fetchApiData();
  }

  Future<Map<String, dynamic>> fetchApiData() async {
    print("https://api.forecast.solar/estimate/${widget.lat}/${widget.long}/${widget.ang}/${widget.azi}/${widget.kap}");
    final url = Uri.parse('https://api.forecast.solar/estimate/${widget.lat}/${widget.long}/${widget.ang}/${widget.azi}/${widget.kap}'); // Replace with your API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }
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
              Navigator.pop(context);
            }, () {
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
                            FutureBuilder<Map<String, dynamic>>(
                              future: futureApiData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  return dailyOverViewCardDesign(snapshot.data!); // Pass API data to chart function
                                } else {
                                  return Center(child: Text('No data available'));
                                }
                              },
                            ),
                            //dailyOverViewCardDesign(),

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

  Widget dailyOverViewCardDesign(Map<String, dynamic> apiData) {
    List<FlSpot> spots = [];
    // Extract the watt-hours data and filter for specific times
    Map<String, dynamic> wattHours = apiData['result']['watts'];
    Map<String, List<int>> targetTimes = {
      '07:00:00': [7, 0],
      '08:00:00': [8, 0],
      '09:00:00': [9, 0],
      '10:00:00': [10, 0],
      '11:00:00': [11, 0],
      '12:00:00': [12, 0],
      '13:00:00': [13, 0],
      '14:00:00': [14, 0],
      '15:00:00': [15, 0],
      '16:00:00': [16, 0],
      '17:00:00': [17, 0],
      '18:00:00': [18, 0],
      '19:00:00': [19, 0],
      '20:00:00': [20, 0],
      '21:00:00': [21, 0],
      '22:00:00': [22, 0],
      '23:00:00': [23, 0],
      '00:00:00': [0, 0],
      '01:00:00': [1, 0],
      '02:00:00': [2, 0],
      '03:00:00': [3, 0],
      '04:00:00': [4, 0],
      '05:00:00': [5, 0],
      '06:00:00': [6, 0],
    };

    DateTime now = DateTime.now(); // Get the current time
    DateTime cutOffTime = DateTime(now.year, now.month, now.day, 17, 00); // Set the cut-off time to 5:30 PM

    wattHours.forEach((time, wattHour) {
      DateTime dateTime = DateTime.parse(time);
      String currentDay = now.toString().split(' ')[0]; // Get the current day in "YYYY-MM-DD" format
      String timeOfDay = time.split(' ')[1]; // Extract the time part of the timestamp

      // Check if the time is one of the target times and after the current time
      if (time.startsWith(currentDay) && targetTimes.containsKey(timeOfDay)) {
        DateTime targetDateTime = DateTime(now.year, now.month, now.day, targetTimes[timeOfDay]![0], targetTimes[timeOfDay]![1]);

        // Add points only if the target time is after the current time but before or equal to 5:30 PM
        if (targetDateTime.isAfter(now) && targetDateTime.isBefore(cutOffTime) || targetDateTime.isAtSameMomentAs(cutOffTime)) {
          double hour = targetTimes[timeOfDay]![0].toDouble() + targetTimes[timeOfDay]![1] / 60;
          spots.add(FlSpot(hour, wattHour.toDouble()));
        }
      }
    });

    // If the current time is past 5:30 PM, fill with zeros
    if (now.isAfter(cutOffTime)) {
      targetTimes.forEach((timeOfDay, value) {
        double hour = value[0].toDouble() + value[1] / 60;
        spots.add(FlSpot(hour, 0));
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Future This Day',
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700 , color: context.isDarkMode ? white : black),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15 , right: 15, top: 10),
          height: 160,
          decoration: BoxDecoration(
            color: containerBlack,
            borderRadius: BorderRadius.circular(20),
          ),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  dotData: const FlDotData(show: false),
                  color: Colors.white,
                  barWidth: 1,
                ),
              ],
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int hour = value.toInt();
                      String period = hour >= 12 ? 'PM' : 'AM';
                      String displayHour = hour > 12 ? '${hour - 12}' : '$hour';
                      return Text(
                        '$displayHour:00 $period',
                        style: TextStyle(fontSize: 7.0, fontWeight: FontWeight.w700, color: Colors.white),
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
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.white),
                  bottom: BorderSide(color: Colors.white),
                ),
              ),
            ),
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
