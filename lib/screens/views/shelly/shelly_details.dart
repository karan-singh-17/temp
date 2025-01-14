import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../domain/classes/utils.dart';

class Shelly_Details extends StatefulWidget {
  String id;
  String name;
  Shelly_Details({super.key, required this.id, required this.name});

  @override
  State<Shelly_Details> createState() => _Shelly_DetailsState();
}

class _Shelly_DetailsState extends State<Shelly_Details> {
  List<dynamic> em_data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDeviceStatus(widget.id); // Call to fetch device status
  }

  Future<void> fetchDeviceStatus(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl =
        prefs.getString('user_api_url'); // Assuming base URL is stored
    final token = prefs.getString('shelly_token');

    if (baseUrl != null) {
      try {
        // Construct the API URL
        final url = Uri.parse('$baseUrl/device/status?id=$deviceId');

        print(url);

        // Perform HTTP GET request
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        print(
            'Response body: ${response.body}'); // Print full response for debugging

        if (response.statusCode == 200) {
          // Parse the JSON response
          final data = jsonDecode(response.body);

          final emeters =
              data['data']?['device_status']?['emeters'] as List<dynamic>?;
          // Log the entire 'data' object to inspect its structure
          print("_________________________________________");
          print('Response Data: ${emeters}');
          setState(() {
            em_data = emeters!;
          });
          // Log the entire 'data' object
        } else {
          print('Failed to load data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching device status: $e');
      }
    } else {
      print('Base URL not found in shared preferences');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? black : white,

      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? white : black,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18, top: 16, bottom: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerDesign(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text("#${widget.id}",
                            style: fontStyling(14.0, FontWeight.w500,
                                isDarkMode ? white : black))),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text("${widget.name}",
                            style: fontStyling(30.0, FontWeight.w500,
                                isDarkMode ? white : black))),
                    SizedBox(
                      height: 40,
                    ),
                    Text("Phase A",
                        style: fontStyling(
                            20.0, FontWeight.w500, isDarkMode ? white : black)),
                    CustomDivider(color: isDarkMode ? white : black),
                    TwoByTwoGrid(
                      current: "${em_data[0]["current"]} A",
                      pf: "${em_data[0]["pf"]}",
                      power: "${em_data[0]["power"]} W",
                      voltage: "${em_data[0]["voltage"]} V",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Phase B",
                        style: fontStyling(
                            20.0, FontWeight.w500, isDarkMode ? white : black)),
                    CustomDivider(color: isDarkMode ? white : black),
                    TwoByTwoGrid(
                      current: "${em_data[1]["current"]} A",
                      pf: "${em_data[1]["pf"]}",
                      power: "${em_data[1]["power"]} W",
                      voltage: "${em_data[1]["voltage"]} V",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Phase C",
                        style: fontStyling(
                            20.0, FontWeight.w500, isDarkMode ? white : black)),
                    CustomDivider(color: isDarkMode ? white : black),
                    TwoByTwoGrid(
                      current: "${em_data[2]["current"]} A",
                      pf: "${em_data[2]["pf"]}",
                      power: "${em_data[2]["power"]} W",
                      voltage: "${em_data[2]["voltage"]} V",
                    ),
                  ],
                ),
              ),
            ),
      // body: emeterData.isEmpty
      //     ? Center(child: CircularProgressIndicator())
      //     : ListView.builder(
      //         itemCount: emeterData.length,
      //         itemBuilder: (context, index) {
      //           final emeter = emeterData[index];
      //           return Card(
      //             margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      //             color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      //             child: ListTile(
      //               title: Text('Emeter ${index + 1}'),
      //               subtitle: Text(
      //                 'Voltage: ${emeter['voltage']} V\n'
      //                 'Power: ${emeter['power']} W\n'
      //                 'PF: ${emeter['pf']}\n'
      //                 'Current: ${emeter['current']} A',
      //                 style: TextStyle(
      //                   color: isDarkMode ? Colors.white : Colors.black,
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       ),
    );
  }

  Widget headerDesign() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SafeArea(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: isDarkMode ? white : black,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "SHELLY DETAILS",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final Color color;

  CustomDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Full screen width
      child: Divider(
        color: color,
        thickness: 3, // You can adjust the thickness as needed
        height: 20, // Adjust the space above and below the divider
      ),
    );
  }
}

class TwoByTwoGrid extends StatelessWidget {
  late String power;
  late String pf;
  late String current;
  late String voltage;

  TwoByTwoGrid(
      {required this.power,
      required this.pf,
      required this.current,
      required this.voltage});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Column(
      mainAxisSize:
          MainAxisSize.min, // Keeps the grid tight around its children
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextWithDivider(
                leftText: "Power",
                rightText: "${power}",
                leftTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
                rightTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomTextWithDivider(
                leftText: "Pf",
                rightText: "${pf}",
                leftTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
                rightTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        //Divider(thickness: 1, color: Colors.grey), // Divider between rows
        Row(
          children: [
            Expanded(
              child: CustomTextWithDivider(
                leftText: "Current",
                rightText: "${current}",
                leftTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
                rightTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomTextWithDivider(
                leftText: "Voltage",
                rightText: "${voltage}",
                leftTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
                rightTextStyle: fontStyling(
                    14.0, FontWeight.w500, isDarkMode ? white : black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomTextWithDivider extends StatelessWidget {
  final String leftText;
  final String rightText;
  final TextStyle? leftTextStyle;
  final TextStyle? rightTextStyle;

  CustomTextWithDivider({
    required this.leftText,
    required this.rightText,
    this.leftTextStyle,
    this.rightTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          border: Border.all(color: isDarkMode ? white : black), // Optional border
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leftText,
              style:
                  leftTextStyle ?? TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          VerticalDivider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
            child: Text(
              rightText,
              style: rightTextStyle ??
                  TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
