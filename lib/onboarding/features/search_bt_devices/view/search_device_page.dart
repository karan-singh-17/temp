import 'dart:async';

import 'package:moe/onboarding/features/search_bt_devices/view/connect_to_device_page.dart';
import 'package:moe/onboarding/util/utils.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:flutter_svg/svg.dart';

class SearchDevicePage extends StatelessWidget {
  const SearchDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchDeviceView(
      connector: context.read(),
    );
  }
}

class SearchDeviceView extends StatefulWidget {
  const SearchDeviceView({
    required this.connector,
    super.key,
  });

  final BLEConnector connector;

  @override
  State<SearchDeviceView> createState() => _SearchDeviceViewState();
}

class _SearchDeviceViewState extends State<SearchDeviceView> {
  _SearchDeviceViewState();
  final List<BLEDeviceAdvertInfo> _devices = [];
  StreamSubscription? _subscription;
  var _clickedDevice = "";

  @override
  void initState() {
    super.initState();
    discoverDevices();
  }

  void discoverDevices() {
    _subscription?.cancel();

    setState(() {
      _devices.clear();
    });

    // Filter Discovery by Service UUID
    _subscription = widget.connector.discoverer
        .discover(withServiceUuids: [advertisedServiceUUID]).listen((device) {
      final index = _devices.map((d) => d.id).toList().indexOf(device.id);
      if (index >= 0) {
        setState(() {
          // replace devices by device ID to update device Name
          _devices[index] = device;
        });
      } else {
        setState(() {
          _devices.add(device);
        });
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    super.dispose();
  }

  Future<void> onSelectDevice(BLEDeviceAdvertInfo info) async {
    final navigator = Navigator.of(context);
    await _subscription?.cancel();
    navigator.push(
      MaterialPageRoute(
        builder: (_) => ConnectToDevicePage(
          deviceInfo: info,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40,
            ),
            SvgPicture.asset(context.isDarkMode
                ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                : "assets/images/deviceaddscreenappiconforlightmode.svg"),
            const SizedBox(
              height: 25,
            ),
            Text('Suchen Sie ${_devices.length} Geräte',
                style: fontStyling(
                  20.0,
                  FontWeight.w600,
                  context.isDarkMode ? white : black,
                )),
            const Text(
              "Wählen Sie ein Gerät aus und klicken Sie auf die Schaltfläche",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: ListView(
                children: _devices
                    .map(
                      (e) => customDeviceFoundDesign(
                          e.name.isEmpty ? e.id : e.name,
                          'assets/images/batalonefordevicefound.png', // Use a placeholder image
                          () {
                        setState(() {
                          _clickedDevice = e.id;
                        });
                        onSelectDevice(e);
                      }, e.id, _clickedDevice),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            !context.isDarkMode ? black : primaryLightBackgroundColor,
        onPressed: discoverDevices,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  ///Card design for showing devices found
  Widget customDeviceFoundDesign(String deviceName, String deviceImage,
      VoidCallback onTap, String deviceId, String clickedDevice) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                const SizedBox(width: 46),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )),
                    child: Row(
                      children: [
                        const SizedBox(width: 70),
                        Expanded(
                            child: Text(deviceName,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ))),
                        if (clickedDevice == deviceId)
                          SvgPicture.asset('assets/images/devieselecttick.svg',
                              height: 24),
                        if (clickedDevice != deviceId)
                          SvgPicture.asset(
                              'assets/images/deviceselectioncircle.svg',
                              height: 24),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Image.asset(deviceImage, height: 91, width: 90))
        ],
      ),
    );
  }
}
