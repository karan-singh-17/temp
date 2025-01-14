import 'dart:async';
import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moe/onboarding/features/cloud_provisioning/view/cloud_provisioning_page.dart';
import 'package:moe/onboarding/features/landing_page/view/wifi_connection_status_view.dart';
import 'package:moe/onboarding/features/rauc/view/rauc_update_page.dart';
import 'package:moe/onboarding/features/search_wifi/view/seach_wifi_page.dart';
import 'package:moe/onboarding/services/navigation_service.dart';
import 'package:moe/onboarding/util/utils.dart';
import 'package:moe/onboarding/util/value_stream_builder.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/services/AWS/IoTLamda/get_put_user_table.dart';
import '../../cloud_provisioning/domain/fetch_provisioning_package.dart';

class LandingPage extends StatelessWidget {
  final BLEDevice device;
  const LandingPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardMultiple(),
          ),
          (route) => false,
        );
        return false;
      },
      child: LandingView(
        device: device,
      ),
    );
  }
}

class LandingView extends StatefulWidget {
  final BLEDevice device;
  const LandingView({super.key, required this.device});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  late final StreamSubscription<BLEConnectionState> _connectionSubscription;
  final GlobalKey<NavigatorState> navigatorKey = NavigationService.navigatorKey;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    print("Initial");
    _connectionSubscription = widget.device.connectionState.listen((state) {
      if (!_isNavigating) {
        if (state == BLEConnectionState.disconnecting ||
            state == BLEConnectionState.disconnected) {
          _isNavigating = true; // Set flag to prevent further navigation
          print("Navigating to DashboardMultiple");
          widget.device.disconnect();

          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardMultiple(),
              ),
              (route) => false,
            ).then((_) {
              _isNavigating = false; // Reset flag when navigation completes
            });
          }
        }
      }
    });
    print(context
        .read<HeimspeicherSystem>()
        .cloudProvisioningStatus
        .valueOrNull
        ?.value
        .toString());
    if (context
            .read<HeimspeicherSystem>()
            .cloudProvisioningStatus
            .valueOrNull
            ?.value
            .toString() !=
        "provisioned") {
      print(context
          .read<HeimspeicherSystem>()
          .cloudProvisioningStatus
          .valueOrNull
          ?.value
          .toString());
      singleFunctionCloudProvisioning(context, widget.device);
      print(context
          .read<HeimspeicherSystem>()
          .cloudProvisioningStatus
          .valueOrNull
          ?.value
          .toString());
    } else {
      print("Provisioned already yeah");
    }
  }

  void singleFunctionCloudProvisioning(
      BuildContext context, BLEDevice device) async {
    final provisioningPackager = ProvisioningPackager();
    final GetPutUserTable userApi = GetPutUserTable();
    String isDownloading = 'Downloading...';

    try {
      // Fetch provisioning package
      await provisioningPackager
          .fetchProvisioningPackage(device.id.replaceAll(":", "_"));
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final filePath = sharedPreferences.getString('provisioningPath');
      if (filePath == null) {
        throw Exception('Provisioning path not found in shared preferences.');
      }
      final provisioningPackage = File(filePath);

      isDownloading = 'Successfully downloaded. Provisioning in progress...';

      // Read data from the provisioning package
      final provisioningData = provisioningPackage.readAsBytesSync();

      // Provision cloud connection
      final heimspeicher = context.read<HeimspeicherSystem>();
      heimspeicher.provisionCloudConnection(provisioningData);

      // Update the user table
      final String systemID = device.id.replaceAll(":", "_");
      await userApi.putUserTableData(systemID);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cloud provisioning complete.'),
        ),
      );
    } catch (e) {
      // Handle errors
      isDownloading = 'Failed to download or provision: ${e.toString()}';
      Fluttertoast.showToast(msg: e.toString());
      return;
    }

    // Optionally display the status
    final status =
        context.read<HeimspeicherSystem>().cloudProvisioningStatus.valueOrNull;
    print('Provisioning status: ${status ?? 'NO DATA'}');


  }

  @override
  void dispose() {
    widget.device.disconnect();
    _connectionSubscription.cancel(); // Avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onConnectToWiFi() async {
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) => const SearchWiFiPage(),
      //   ),
      // );
    }

    Future<void> onDisconnectWiFi() async {
      await context.read<HeimspeicherSystem>().disconnectWiFi();
    }

    Future<void> onRaucUpdate() async {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (c) => const RaucUpdatePage()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardMultiple(),
          ),
              (route) => false,
        );
        return false;
      },
      child: ValueStreamBuilder(
        stream: context.read<HeimspeicherSystem>().wifiStatusStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Placeholder();
          }

          final wiFiStatus = snapshot.data!;

          return Scaffold(
            backgroundColor:
                context.isDarkMode ? black : primaryLightBackgroundColor,
            appBar: AppBar(
              backgroundColor:
                  context.isDarkMode ? black : primaryLightBackgroundColor,
              titleSpacing: 23,
              title: Text(widget.device.name,
                  style: fontStyling(
                    20.0,
                    FontWeight.w500,
                    context.isDarkMode ? white : black,
                  )),
              /*actions: const [
                Icon(Icons.wifi),
                WifiConnectionStatusView(),
                SizedBox(width: 5),
              ],*/
            ),
            // floatingActionButton: Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     if (wiFiStatus != WiFiStatus.connected)
            //       FloatingActionButton.extended(
            //         onPressed: onConnectToWiFi,
            //         label: const Icon(Icons.search),
            //         icon: const Icon(Icons.wifi),
            //       ),
            //     if (wiFiStatus == WiFiStatus.connected)
            //       FloatingActionButton.extended(
            //         onPressed: onRaucUpdate,
            //         label: const Text("Rauc Update"),
            //         icon: const Icon(Icons.system_update),
            //       ),
            //   ],
            // ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(44, 44, 44, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'WiFi Status',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: fontStyling(
                                19.0,
                                FontWeight.w500,
                                white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.wifi,
                              color:
                                  WifiConnectionStatusView.stateColor(wiFiStatus),
                              size: 80,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            wiFiStatus.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                            style: fontStyling(
                              15.0,
                              FontWeight.w500,
                              white,
                            ),
                          ),
                          const SizedBox(height: 18),
                          (wiFiStatus == WiFiStatus.connected)
                              ? borderLandingUiButton(
                                  () => onDisconnectWiFi(),
                                  "Disconnect",
                                  white,
                                  white,
                                )
                              : borderLandingUiButton(
                                  () => onConnectToWiFi(),
                                  "Connect",
                                  white,
                                  white,
                                ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(44, 44, 44, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'RAUC Update',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: fontStyling(
                                16.0,
                                FontWeight.w500,
                                white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.system_update,
                              color: white,
                              size: 80,
                            ),
                          ),
                          const SizedBox(height: 18),
                          (wiFiStatus == WiFiStatus.connected)
                              ? borderLandingUiButton(
                                  () {
                                    print(widget.device.connectionState.value ==
                                        BLEConnectionState.connected);

                                    onRaucUpdate();
                                  },
                                  "Update",
                                  white,
                                  white,
                                )
                              : borderLandingUiButton(
                                  () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Add Wifi To Device'),
                                      ),
                                    );
                                  },
                                  "Update",
                                  white,
                                  white,
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "EXIT",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
