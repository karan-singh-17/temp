import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/screens/views/authentication/login.dart';
import 'package:moe/screens/views/batterychargestatusscreen/BatteryChargeStatusScreen.dart';
import 'package:moe/screens/views/currentconsumptionscreen/CurrentConsumptionScreen.dart';
import 'package:moe/screens/views/monetorysavingsoverviewScreen/MonetarySavingsOverviewScreen.dart';
import 'package:moe/screens/views/productionscreen/CurrentProductionScreen.dart';
import 'package:moe/screens/views/profileandsettingscreen/ProfileSettingScreen.dart';
import 'package:moe/screens/widgets/customNavBar.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../../../../data/services/AWS/aws_services.dart';
import '../../../../domain/classes/utils.dart';

Future<WebSocketChannel> connectWebSocket(String tableName) async {
  final uri = Uri.parse(
      'wss://ojil6u53db.execute-api.eu-central-1.amazonaws.com/production/?tableName=$tableName' /*EnergyData_v3*/);
  final channel = WebSocketChannel.connect(uri);

  final initialPayload = jsonEncode({
    'action': 'sendMessage',
    'body': jsonEncode({'tableName': tableName}),
  });

  try {
    await channel.ready;
    print("Connection established");
    channel.sink.add(initialPayload);
    print("Initial payload sent: $initialPayload");
    return channel;
  } on SocketException catch (e) {
    print("SocketException: ${e.toString()}");
    rethrow;
  } on WebSocketChannelException catch (e) {
    print('WebSocketChannelException: $e');
    rethrow;
  } catch (e) {
    print("Exception: ${e.toString()}");
    rethrow;
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final UserAuthProvider userAuthProvider = UserAuthProvider();
  late WebSocketChannel channel;
  bool isLoading = true;
  List<String> device_ids = [];
  String? receivedData;
  int? averageBatteryPercentage = 0;
  int? battery_pow = 0;
  List<int> batteryPercentages = [];
  int? total_pow_MPPT = 0;
  int? pow_inv = 0;
  int selected = 0;
  bool isDetailView =
      false; // Track whether to show the detail view or the list
  String selectedDeviceId = ''; // Store the selected device ID

  // Function to switch to detailed view
  void showDetailView(String deviceId) {
    setState(() {
      isDetailView = true;
      selectedDeviceId = deviceId;
    });
  }

  // Function to switch back to the list view
  void showListView() {
    setState(() {
      isDetailView = false;
    });
  }

  @override
  void initState() {
    super.initState();
    init_user();
  }

  init_user() async {
    await _initializeUserDevices('ksckaran25@gmail.com');
    _initializeWebSocket(device_ids[selected]);
  }

  Future<void> _initializeUserDevices(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://240ko4d457.execute-api.eu-central-1.amazonaws.com/production/user_data?email=$userId"),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var x in jsonData['registered_systems']) {
          print(x);
          device_ids.add(x);
        }
      } else {
        print("Failed to load user data. Status code: ${response.statusCode}");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _initializeWebSocket(String tableName) async {
    channel = await connectWebSocket(tableName);

    channel.stream.listen(
      (onData) {
        print("Received data: ${onData.toString()}");
        _handleIncomingData(onData.toString());
      },
      onError: (error) {
        print("Error received: $error");
      },
      onDone: () {
        print("WebSocket connection closed.");
      },
    );
  }

  void _handleIncomingData(String data) {
    setState(() {
      receivedData = data;
    });

    var jsonData = jsonDecode(data);

    if (jsonData is List) {
      // Initial full dataset message
      for (var item in jsonData) {
        if (item.containsKey('Battery')) {
          Map<String, dynamic> batteryData =
              jsonDecode(item['Battery']['Data']);
          batteryData.forEach((key, value) {
            String socString = value['SOC'].replaceAll('%', '');
            int soc = int.parse(socString);
            batteryPercentages.add(soc);
          });
          Map<String, dynamic> batteryPowData =
              jsonDecode(item['Battery']['Data']);
          batteryPowData.forEach((key, value) {
            String powString = value['Power'].replaceAll('W', '');
            int pow = int.parse(powString);
            battery_pow = battery_pow! + pow;
          });
        }
        if (item.containsKey('MPPT')) {
          Map<String, dynamic> mpptData = jsonDecode(item['MPPT']['Data']);
          mpptData.forEach((key, value) {
            String powerString = value['Power'].replaceAll('W', '');
            int power = int.parse(powerString);
            total_pow_MPPT = total_pow_MPPT! + power;
          });
        }
        if (item.containsKey('Inverter')) {
          Map<String, dynamic> inverterData =
              jsonDecode(item['Inverter']['Data']);
          // No need to use forEach since we know the structure
          String powerString = inverterData['Power'].replaceAll('W', '');
          int power = int.parse(powerString);
          pow_inv = power.abs();
        }
      }
    } else {
      if (jsonData.containsKey('Battery')) {
        // Subsequent individual battery message
        Map<String, dynamic> batteryData = jsonDecode(jsonData['Battery']);
        batteryData.forEach((key, value) {
          String socString = value['SOC'].replaceAll('%', '');
          int soc = int.parse(socString);
          batteryPercentages.add(soc);
        });
        int z = 0;
        Map<String, dynamic> batteryPowData = jsonDecode(jsonData['Battery']);
        batteryPowData.forEach((key, value) {
          String powString = value['Power'].replaceAll('W', '');
          int pow = int.parse(powString);
          z = z + pow;
        });
        battery_pow = z;
      }
      if (jsonData.containsKey('MPPT')) {
        int m = 0;
        Map<String, dynamic> mpptData = jsonDecode(jsonData['MPPT']);
        mpptData.forEach((key, value) {
          String powerString = value['Power'].replaceAll('W', '');
          int power = int.parse(powerString);
          m = m + power;
        });
        total_pow_MPPT = m;
      }
      if (jsonData.containsKey('Inverter')) {
        Map<String, dynamic> inverterData = jsonDecode(jsonData['Inverter']);
        // No need to use forEach since we know the structure
        String powerString = inverterData['Power'].replaceAll('W', '');
        int power = int.parse(powerString);
        pow_inv = power.abs();
      }
    }
    setState(() {
      averageBatteryPercentage = _calculateAverageBatteryPercentage();
    });
  }

  int _calculateAverageBatteryPercentage() {
    if (batteryPercentages.isEmpty) {
      return 0;
    }
    int sum = batteryPercentages.reduce((a, b) => a + b);
    return (sum / batteryPercentages.length).round();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var scColorInv = isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    var txColorInv = isDarkMode ? TextColor().light : TextColor().dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: scColor,
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(
              color: txColor,
            ))
          : device_ids.isEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      headerDesign(),
                      const SizedBox(
                        height: 55,
                      ),
                      Container(child: Text("No Device"))
                    ],
                  ),
                )
              : (device_ids.length == 1)
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      color: scColor,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          //Header design
                          headerDesign(),
                          // SizedBox(
                          //   height: 10, // Adjust height as needed
                          //   child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: device_ids.length,
                          //     itemBuilder: (context, index) {
                          //       return Padding(
                          //         padding:
                          //             const EdgeInsets.symmetric(horizontal: 5),
                          //         child: InkWell(
                          //           onTap: () {
                          //             setState(() {
                          //               selected = index;
                          //               channel.sink;
                          //               averageBatteryPercentage = 0;
                          //               battery_pow = 0;
                          //               batteryPercentages = [];
                          //               total_pow_MPPT = 0;
                          //               pow_inv = 0;
                          //               _initializeWebSocket(
                          //                   device_ids[selected]);
                          //             });
                          //           },
                          //           child: Container(
                          //             alignment: Alignment.center,
                          //             padding: const EdgeInsets.all(6),
                          //             decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(20),
                          //                 color: (selected == index)
                          //                     ? scColorInv
                          //                     : containerBlack),
                          //             child: Text(
                          //               device_ids[index],
                          //               style: fontStyling(
                          //                   13.0,
                          //                   FontWeight.w400,
                          //                   (selected == index)
                          //                       ? txColorInv
                          //                       : txColor),
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  //Top card layout design
                                  firstCardDesign(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //bottom layout design with GIFs
                                  bottomLayoutDesign()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      color: scColor,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          //Header design
                          headerDesign(),
                          const SizedBox(
                            height: 10,
                          ),

                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(
                                  milliseconds: 300), // Animation duration
                              child: isDetailView
                                  ? buildDetailView() // Show detail view if an item was clicked
                                  : buildListView(), // Show list view by default
                            ),
                          ),
                        ],
                      ),
                    ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget buildListView() {
    return SingleChildScrollView(
      child: Column(
        key: ValueKey('listView'), // Unique key for the list view
        children: [
          firstCardDesign(),
          const SizedBox(
            height: 10,
          ),
          multi_dev_header(),
          const SizedBox(height: 10),
          Column(
            children: List.generate(device_ids.length, (index) {
              return GestureDetector(
                onTap: () {
                  // Show the detail view on item click
                  showDetailView(device_ids[index]);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 5, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: containerBlack,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MOE',
                                style: fontStyling(15.0, FontWeight.w500,
                                    primaryLightBackgroundColor),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Text(
                                    device_ids[index],
                                    style: fontStyling(20.0, FontWeight.w500,
                                        primaryLightBackgroundColor),
                                  ),
                                  const SizedBox(width: 6.0),
                                  SvgPicture.asset(
                                    'assets/images/dashboardcrossarrow.svg',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/cont_pannel.svg',
                        height: 90.0,
                        width: 90.0,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Build the detailed view
  Widget buildDetailView() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      key: ValueKey('detailView'), // Unique key for the detail view
      children: [
        const SizedBox(height: 15),
        // Back button to return to list view
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon:
                    Icon(Icons.arrow_back, color: !isDarkMode ? black : white),
                onPressed: showListView, // Switch back to list view
              ),
            ),
            // Your detailed layout
            const SizedBox(width: 7),
            Text(
              '$selectedDeviceId',
              style: fontStyling(
                  20.0, FontWeight.bold, !isDarkMode ? black : white),
            ),
          ],
        ),
        const SizedBox(height: 15),

        bottomLayoutDesign()
      ],
    );
  }

  multi_dev_header() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Example SVG image paths (replace with your own assets)
    final List<String> svgPaths = [
      'assets/images/dashboardpaneliamge.svg',
      'assets/images/multicolorhouse.svg',
      'assets/images/dashboardcellimage.svg',
    ];

    // Corresponding text for each SVG
    final List<Map<String, String>> textData = [
      {"small": "PRODUKTION", "large": "800 WATT"},
      {"small": "VERBRAUCH", "large": "400 WATT"},
      {"small": "LADEZUSTAND", "large": "78 %"},
    ];

    return Container(
      padding: const EdgeInsets.all(16.0), // Padding for the container
      decoration: BoxDecoration(
        color: containerBlack,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top left text
          Text(
            "AKTUELL",
            style:
                fontStyling(12.0, FontWeight.w300, primaryLightBackgroundColor),
          ),
          const SizedBox(
              height: 16.0), // Space between text and the row of SVGs

          // Row of SVGs with text below each
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(svgPaths.length, (index) {
              return Column(
                children: [
                  // SVG icon
                  SvgPicture.asset(
                    svgPaths[index],
                    height: 70.0, // Customize height
                    width: 70.0, // Customize width
                  ),
                  const SizedBox(height: 8.0), // Space between SVG and text

                  // RichText with smaller and bigger text
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${textData[index]["small"]}\n', // Smaller text
                          style: fontStyling(8.0, FontWeight.w300,
                              primaryLightBackgroundColor),
                        ),
                        TextSpan(
                          text: textData[index]["large"]!
                              .split(' ')[0], // The large number
                          style: fontStyling(19.0, FontWeight.w700,
                              primaryLightBackgroundColor),
                        ),
                        TextSpan(
                          text:
                              '  ${textData[index]["large"]!.split(' ')[1]}', // The smaller unit
                          style: fontStyling(11.0, FontWeight.w400,
                              primaryLightBackgroundColor),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  //Header design
  headerDesign() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      top: true,
      minimum: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            "DEIN MOE SYSTEM",
            style:
                fontStyling(26.0, FontWeight.w700, isDarkMode ? white : black),
          ),
          const Spacer(),
          GestureDetector(
            onLongPress: () async {
              await userAuthProvider.signOutCurrentUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profilesettingscreen(),

                    ///Navigate to setting screen
                  ));
            },
            child: Icon(
              Icons.add_circle_outline,
              color: isDarkMode ? white : black,
              size: 30,
            ),
          )
          // child: SvgPicture.asset(isDarkMode
          //     ? "assets/images/darkmodeprofileicon.svg"
          //     : "assets/images/lightmodeprofileicon.svg"))
        ],
      ),
    );
  }

  //Top cart layout design
  firstCardDesign() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MonetarySavingsOverviewScreen(),
            ));

        ///navigate to monetary saving screen
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: containerBlack, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text("GESAMT",
                  style: fontStyling(
                      12.0, FontWeight.w300, primaryLightBackgroundColor)),
              const Spacer(),
              SvgPicture.asset(
                "assets/images/dashboardcrossarrow.svg",
                height: 24,
                width: 24,
              )
            ]),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("MONETÄRE",
                    style: fontStyling(
                        22.0, FontWeight.w700, primaryLightBackgroundColor)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "4.800",
                        style: fontStyling(
                            22.0, FontWeight.w700, primaryLightBackgroundColor),
                      ),
                      TextSpan(
                        text: "  kwH",
                        style: fontStyling(
                            14.0, FontWeight.w300, primaryLightBackgroundColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("EINSPARUNG",
                    style: fontStyling(
                        22.0, FontWeight.w700, primaryLightBackgroundColor)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "1.900",
                        style: fontStyling(
                            22.0, FontWeight.w700, primaryLightBackgroundColor),
                      ),
                      TextSpan(
                        text: "  €",
                        style: fontStyling(
                            14.0, FontWeight.w300, primaryLightBackgroundColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Text("MONETÄRE\nEINSPARUNG",
            //     style: fontStyling(
            //         25.0, FontWeight.w700, primaryLightBackgroundColor)),
            // const SizedBox(
            //   height: 10,
            // ),
            // Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            //   Expanded(
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text(
            //           "4.800",
            //           style: fontStyling(
            //               28.0, FontWeight.w700, primaryLightBackgroundColor),
            //         ),
            //         const SizedBox(
            //           width: 5,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(bottom: 5),
            //           child: Text("kwH",
            //               style: fontStyling(16.0, FontWeight.w300,
            //                   primaryLightBackgroundColor)),
            //         ),
            //       ],
            //     ),
            //   ),
            //   Expanded(
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text(
            //           "1.900",
            //           style: fontStyling(
            //               28.0, FontWeight.w700, primaryLightBackgroundColor),
            //         ),
            //         const SizedBox(
            //           width: 5,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(bottom: 5),
            //           child: Text("€",
            //               style: fontStyling(16.0, FontWeight.w300,
            //                   primaryLightBackgroundColor)),
            //         ),
            //       ],
            //     ),
            //   ),
            // ]),
          ],
        ),
      ),
    );
  }

  //bottom layout design with GIFs
  bottomLayoutDesign() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: containerBlack,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CurrentProductionscreen(),
                      ));

                  ///Navigate to current production screen
                },
                child: SvgPicture.asset(
                  "assets/images/dashboardpaneliamge.svg",
                  height: 90,
                  width: 90,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Text("AKTUELLE \nPRODUKTION",
                      style: fontStyling(10.0, FontWeight.w300, white)),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      total_pow_MPPT == 0
                          ? JumpingDots(
                              numberOfDots: 3,
                              color: primaryLightBackgroundColor,
                              radius: 5,
                              innerPadding: 2,
                              verticalOffset: 4,
                            )
                          : Text(
                              total_pow_MPPT!.toString(),
                              style: fontStyling(20.0, FontWeight.w700,
                                  primaryLightBackgroundColor),
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("WATT",
                            style: fontStyling(10.0, FontWeight.w700,
                                primaryLightBackgroundColor)),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  child: Image.asset(
                    "assets/images/whiteverticalline.gif",
                    height: 240,
                  ),
                ),
                Positioned(
                  left: 50,
                  child: Image.asset(
                    "assets/images/dashboardblueline.gif",
                    height: 110,
                  ),
                ),
                Positioned(
                  left: 50,
                  bottom: 0,
                  child: Image.asset(
                    "assets/images/dashboardgreenline.gif",
                    height: 115,
                  ),
                ),
                Positioned(
                  left: 125,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) =>
                    //             const CurrentConsumptionScreen(),
                    //
                    //         ///Navigate to current consumption screen
                    //       ));
                    // },
                    child: SvgPicture.asset(
                      "assets/images/multicolorhouse.svg",
                      height: 90,
                      width: 90,
                    ),
                  ),
                ),
                Positioned(
                  left: 213,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("AKTUELLER \nVERBRAUCH",
                          style: fontStyling(10.0, FontWeight.w300, white)),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          pow_inv == 0
                              ? JumpingDots(
                                  numberOfDots: 3,
                                  color: primaryLightBackgroundColor,
                                  radius: 5,
                                  innerPadding: 2,
                                  verticalOffset: 4,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 2.5),
                                  child: Text(
                                    pow_inv.toString(),
                                    style: fontStyling(13.0, FontWeight.w700,
                                        primaryLightBackgroundColor),
                                  ),
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text("WATT",
                                style: fontStyling(10.0, FontWeight.w700,
                                    primaryLightBackgroundColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 70,
                  top: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (battery_pow == 0 || pow_inv == 0)
                          ? JumpingDots(
                              numberOfDots: 3,
                              color: primaryLightBackgroundColor,
                              radius: 5,
                              innerPadding: 2,
                              verticalOffset: 4,
                            )
                          : Text("${(battery_pow! - pow_inv!).abs()} WATT",
                              style: fontStyling(9.0, FontWeight.w600, white)),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 70,
                  top: 145,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (battery_pow == 0)
                          ? JumpingDots(
                              numberOfDots: 3,
                              color: primaryLightBackgroundColor,
                              radius: 5,
                              innerPadding: 2,
                              verticalOffset: 4,
                            )
                          : Text(
                              "${battery_pow!} WATT",
                              style: fontStyling(9.0, FontWeight.w600, white),
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 0,
                  bottom: 0,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (battery_pow == 0 ||
                                pow_inv == 0 ||
                                total_pow_MPPT == 0)
                            ? JumpingDots(
                                numberOfDots: 3,
                                color: primaryLightBackgroundColor,
                                radius: 5,
                                innerPadding: 2,
                                verticalOffset: 4,
                              )
                            : Text(
                                "${(total_pow_MPPT! - (battery_pow! - pow_inv!).abs()).abs()} WATT",
                                style:
                                    fontStyling(9.0, FontWeight.w600, white)),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           const BatteryCharegeStatusScreen(),
                  //     ));

                  ///Navigate to battery charging status screen
                },
                child: SvgPicture.asset(
                  "assets/images/dashboardcellimage.svg",
                  height: 90,
                  width: 90,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Text("LADEZUSTAND \nBATTERIE",
                      style: fontStyling(10.0, FontWeight.w300, white)),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      averageBatteryPercentage == 0
                          ? JumpingDots(
                              numberOfDots: 3,
                              color: primaryLightBackgroundColor,
                              radius: 5,
                              innerPadding: 2,
                              verticalOffset: 4,
                            )
                          : Text(
                              averageBatteryPercentage!.toString(),
                              style: fontStyling(20.0, FontWeight.w700,
                                  primaryLightBackgroundColor),
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("%",
                            style: fontStyling(10.0, FontWeight.w700,
                                primaryLightBackgroundColor)),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
