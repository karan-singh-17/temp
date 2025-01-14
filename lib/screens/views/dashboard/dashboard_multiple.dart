import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:moe/data/services/AWS/IoTLamda/get_put_user_table.dart';
import 'package:moe/data/services/AWS/IoTLamda/iot_data_model.dart';
import 'package:moe/data/services/AWS/IoTLamda/system_provider.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/domain/helper/Database_Helper(local).dart';
import 'package:moe/screens/views/dashboard/attributeTest.dart';
import 'package:moe/screens/views/shelly/shelly_home.dart';
import 'package:provider/provider.dart';

import '../../../data/services/AWS/aws_services.dart';
import '../../../domain/classes/utils.dart';
import '../../../onboarding/app/view/app.dart';
import '../../widgets/customNavBar.dart';
import '../authentication/login.dart';
import '../batterychargestatusscreen/BatteryChargeStatusScreen.dart';
import '../currentconsumptionscreen/CurrentConsumptionScreen.dart';
import '../monetorysavingsoverviewScreen/MonetarySavingsOverviewScreen.dart';
import '../profileandsettingscreen/ProfileSettingScreen.dart';

class DashboardMultiple extends StatefulWidget {
  const DashboardMultiple({super.key});

  @override
  State<DashboardMultiple> createState() => _DashboardMultipleState();
}

class _DashboardMultipleState extends State<DashboardMultiple> {
  bool isLoading = true;
  final UserAuthProvider userAuthProvider = UserAuthProvider();

  @override
  void initState() {
    super.initState();
    initSystems();
  }

  Future<void> initSystems() async {
    GetPutUserTable userApi = GetPutUserTable();
    List<String>? deviceIDs = await userApi.fetchUserSystems();

    if (deviceIDs != null) {
      final deviceProvider =
          Provider.of<DeviceProvider>(context, listen: false);

      for (String id in deviceIDs) {
        System? existingSystem = deviceProvider.getDeviceById(id);

        if (existingSystem == null) {
          await deviceProvider.addDevice(System(
            id: id,
            batteries: [],
            inverter: Inverter(id: id, busPower: "0.0"),
            solarPanels: [],
          ));
        } else {
          print('System with id $id already exists');
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isDetailView = false;
  String selectedDeviceId = '';

  void showDetailView(String deviceId) {
    setState(() {
      isDetailView = true;
      selectedDeviceId = deviceId;
    });
  }

  void showListView() {
    setState(() {
      isDetailView = false;
      selectedDeviceId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: true);
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
          : deviceProvider.devices.isEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      headerDesign(context),
                      const SizedBox(
                        height: 55,
                      ),
                      Expanded(
                        child: Container(
                            child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.devices,
                                color: isDarkMode
                                    ? primaryLightBackgroundColor
                                    : black,
                                size: 40,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text("No Device Added",
                                  style: fontStyling(
                                      25.0,
                                      FontWeight.w500,
                                      isDarkMode
                                          ? primaryLightBackgroundColor
                                          : black)),
                              SizedBox(
                                height: 6,
                              ),
                              Text("Click on + to add device",
                                  style: fontStyling(
                                      15.0,
                                      FontWeight.w400,
                                      isDarkMode
                                          ? primaryLightBackgroundColor
                                          : black)),
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                )
              : (deviceProvider.devices.length == 1)
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
                          headerDesign(context),
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
                                    height: 11,
                                  ),
                                  //bottom layout design with GIFs
                                  bottomLayoutDesign(selec_id: deviceProvider.devices[0].id)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 11),
                      color: scColor,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          //Header design
                          headerDesign(context),
                          const SizedBox(
                            height: 10,
                          ),

                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(
                                  milliseconds: 300), // Animation duration
                              child: isDetailView
                                  ? buildDetailView(
                                      deviceProvider) // Show detail view if an item was clicked
                                  : buildListView(
                                      deviceProvider), // Show list view by default
                            ),
                          ),
                        ],
                      ),
                    ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget buildListView(DeviceProvider deviceProvider) {
    return SingleChildScrollView(
      child: Column(
        key: ValueKey('listView'), // Unique key for the list view
        children: [
          firstCardDesign(),
          const SizedBox(
            height: 10,
          ),
          multi_dev_header(deviceProvider, context),
          const SizedBox(height: 10),
          Column(
            children: List.generate(deviceProvider.devices.length, (index) {
              return GestureDetector(
                onTap: () {
                  // Show the detail view on item click
                  showDetailView(deviceProvider.devices[index].id);
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
                                    deviceProvider.devices[index].id,
                                    style: fontStyling(15.0, FontWeight.w500,
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
  Widget buildDetailView(DeviceProvider deviceProvider) {
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

        bottomLayoutDesign(
          selec_id: selectedDeviceId,
        )
      ],
    );
  }

  Widget multi_dev_header(DeviceProvider deviceProvider, BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // SVG Paths
    final String productionSvgPath = 'assets/images/dashboardpaneliamge.svg';
    final String consumptionSvgPath = 'assets/images/multicolorhouse.svg';
    final String batterySvgPath = 'assets/images/dashboardcellimage.svg';

    // Text Data
    final String productionTextSmall = "PRODUKTION";

    final String consumptionTextSmall = "VERBRAUCH";

    final String batteryTextSmall = "LADEZUSTAND";

    int calculateAverageBatteryPercentage(DeviceProvider deviceProvider) {
      List<System> systems = deviceProvider.getAllSystems();
      double totalBatteryPercentage = 0.0;
      int batteryCount = 0;

      for (var system in systems) {
        for (var battery in system.batteries) {
          double? stateOfCharge = double.tryParse(battery.stateOfCharge);
          if (stateOfCharge != null) {
            totalBatteryPercentage += stateOfCharge;
            batteryCount++;
          }
        }
      }
      return batteryCount > 0
          ? (totalBatteryPercentage / batteryCount).round()
          : 0;
    }

    int getTotalBusPower(DeviceProvider deviceProvider) {
      List<System> systems = deviceProvider.getAllSystems();
      if (systems.isEmpty) return 0;

      int totalBusPower = 0;

      for (var system in systems) {
        List<Battery> batteries = system.batteries;
        if (batteries.isEmpty) return 0;
        totalBusPower += batteries
            .map((battery) =>
                int.tryParse(battery.busPower)?.abs() ??
                0) // Parse busPower to double
            .reduce((a, b) => a + b); // Sum all valid busPower values
      }
      return totalBusPower;
    }

    int getTotalBusPower_Solar(DeviceProvider deviceProvider) {
      List<System> systems = deviceProvider.getAllSystems();
      if (systems.isEmpty) return 0;

      int totalBusPower = 0;

      for (var system in systems) {
        List<Solar> solar = system.solarPanels;
        if (solar.isEmpty) return 0;
        totalBusPower += solar
            .map((solar) =>
                int.tryParse(solar.busPower)?.abs() ??
                0) // Parse busPower to double
            .reduce((a, b) => a + b);
      }
      return totalBusPower;
    }

    final int averageBatteryPercentage =
        calculateAverageBatteryPercentage(deviceProvider);
    final String batteryTextLarge = "$averageBatteryPercentage%";
    final String productionTextLarge =
        "${getTotalBusPower(deviceProvider)} WATT";
    final String consumptionTextLarge =
        "${getTotalBusPower_Solar(deviceProvider)} WATT";

    return Container(
      padding: const EdgeInsets.all(15.0),
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
          const SizedBox(height: 16.0),

          // Row of SVGs with text below each
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSvgColumn(
                  productionSvgPath, productionTextSmall, productionTextLarge),
              buildSvgColumn(consumptionSvgPath, consumptionTextSmall,
                  consumptionTextLarge),
              buildSvgColumn(
                  batterySvgPath, batteryTextSmall, batteryTextLarge),
            ],
          ),
        ],
      ),
    );
  }

  Column buildSvgColumn(String svgPath, String textSmall, String textLarge) {
    List<String> largeTextParts = textLarge.split(' ');

    return Column(
      children: [
        // SVG icon
        SvgPicture.asset(
          svgPath,
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
                text: '$textSmall\n', // Smaller text
                style: fontStyling(
                    8.0, FontWeight.w300, primaryLightBackgroundColor),
              ),
              TextSpan(
                text: largeTextParts.isNotEmpty
                    ? largeTextParts[0]
                    : '', // The large number
                style: fontStyling(
                    19.0, FontWeight.w700, primaryLightBackgroundColor),
              ),
              TextSpan(
                text: largeTextParts.length > 1
                    ? ' ${largeTextParts[1]}'
                    : '', // The smaller unit
                style: fontStyling(
                    11.0, FontWeight.w400, primaryLightBackgroundColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Header design
  Widget headerDesign(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SafeArea(
      top: true,
      minimum: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: PopupMenuButton<String>(
              color: !isDarkMode ? black : white,
              onSelected: (value) {
                if (value == "newScreen") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            Shelly_Home()), // Replace with your new screen widget
                  );
                }
              },
              offset: const Offset(0, 40), // Adjust to position menu below text
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  value: "newScreen",
                  child: Text("Shelly Devices",
                      style: fontStyling(
                          17.0, FontWeight.w500, !isDarkMode ? white : black)),
                ),
              ],
              child: Row(
                children: [
                  Text(
                    "DEIN MOE SYSTEM",
                    style: fontStyling(
                        26.0, FontWeight.w700, isDarkMode ? white : black),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_drop_down,
                    color: isDarkMode ? white : black,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onDoubleTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => UserAttributesScreen()));
            },
            onLongPress: () async {
              await userAuthProvider.signOutCurrentUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
              Navigator.pushNamed(context, '/onboard_app');
            },
            child: Icon(
              Icons.add_circle_outline,
              color: isDarkMode ? white : black,
              size: 30,
            ),
          ),
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
          ],
        ),
      ),
    );
  }

  //bottom layout design with GIFs
}

class bottomLayoutDesign extends StatefulWidget {
  final String selec_id;
  const bottomLayoutDesign({super.key, required this.selec_id});

  @override
  State<bottomLayoutDesign> createState() => _bottomLayoutDesignState();
}

class _bottomLayoutDesignState extends State<bottomLayoutDesign> {
  List<Map<String, dynamic>> systems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_pannels();
  }

  get_pannels() async {
    try {
      List<Map<String, dynamic>> temp =
          await DatabaseHelper().getSystemsBySystemId(widget.selec_id);
      setState(() {
        systems = temp;
      });
    } catch (e) {
      print("Error fetching systems: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int getAverageStateOfCharge(List<Battery> batteries) {
      if (batteries.isEmpty) {
        return 0;
      }

      List<double> validStateOfCharges = batteries
          .map((battery) => double.tryParse(battery.stateOfCharge) ?? 0)
          .toList();

      double totalStateOfCharge = validStateOfCharges.reduce((a, b) => a + b);

      double average = totalStateOfCharge / batteries.length;

      return average.round();
    }

    int getTotalBusPower(List<Battery> batteries) {
      if (batteries.isEmpty) {
        return 0;
      }

      int totalBusPower = batteries
          .map((battery) =>
              int.tryParse(battery.busPower)?.abs() ??
              0) // Parse busPower to double
          .reduce((a, b) => a + b); // Sum all valid busPower values

      return totalBusPower;
    }

    int getTotalBusPower_Solar(List<Solar> solar) {
      if (solar.isEmpty) {
        return 0; // Handle the case where the list is empty
      }

      int totalBusPower = solar
          .map((solar) =>
              int.tryParse(solar.busPower)?.abs() ??
              0) // Parse busPower to double
          .reduce((a, b) => a + b); // Sum all valid busPower values

      return totalBusPower;
    }

    final deviceProvider = Provider.of<DeviceProvider>(context, listen: true);

    System system = (deviceProvider.devices.length > 1)
        ? deviceProvider.devices
            .firstWhere((system) => system.id == widget.selec_id)
        : deviceProvider.devices[0];

    int? averageBatteryPercentage = getAverageStateOfCharge(system.batteries);
    int? battery_pow = getTotalBusPower(system.batteries);

    int? total_pow_MPPT = getTotalBusPower_Solar(system.solarPanels);

    int? pow_inv = int.tryParse(system.inverter.busPower)?.abs();

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
              (systems.isNotEmpty)
                  ? GestureDetector(
                      onTap: () {
                        print(widget.selec_id);
                        Navigator.pushNamed(context, '/addModule',
                                arguments: widget.selec_id)
                            .then((_) {
                          setState(() {
                            get_pannels();
                          });
                        });
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AddModuleScreen(
                        //         selec_id: widget.selec_id,
                        //       ),
                        //     ));

                        ///Navigate to current production screen
                      },
                      child: SvgPicture.asset(
                        "assets/images/dashboardpaneliamge.svg",
                        height: 90,
                        width: 90,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        print(widget.selec_id);
                        print(2);
                        Navigator.pushNamed(context, '/addModule',
                                arguments: widget.selec_id)
                            .then((_) {
                          setState(() {
                            get_pannels();
                          });
                        });

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AddModuleScreen(
                        //         selec_id: widget.selec_id,
                        //       ),
                        //     ));
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.black38, // Button background color
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '+',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'ADD CELL',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
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
                      (systems.isNotEmpty)
                          ? total_pow_MPPT == 0
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
                                )
                          : Text(total_pow_MPPT!.toString(),
                              style: fontStyling(20.0, FontWeight.w700,
                                  primaryLightBackgroundColor)),
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrentConsumptionScreen(
                                inverter: system.inverter, avg_pow: pow_inv!),

                            ///Navigate to current consumption screen
                          ));
                    },
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
                                "${(total_pow_MPPT! - (battery_pow! - pow_inv!).abs()).abs()} WAT",
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
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => BatteryCharegeStatusScreen(
                          batteries: system.batteries,
                          average_batt: battery_pow,
                        ),
                      ));

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
