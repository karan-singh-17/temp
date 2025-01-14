import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moe/onboarding/features/landing_page/view/landing_page.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/cupertino.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';

import '../../../screens/views/dashboard/dashboard_multiple.dart';
import '../../features/search_wifi/view/seach_wifi_page.dart';

class AfterDeviceConnectedWrapper extends StatefulWidget {
  const AfterDeviceConnectedWrapper({
    required this.device,
    required this.chunkSize,
    super.key,
  });

  final BLEDevice device;
  final int chunkSize;

  @override
  State<AfterDeviceConnectedWrapper> createState() =>
      _AfterDeviceConnectedWrapperState();
}

class _AfterDeviceConnectedWrapperState
    extends State<AfterDeviceConnectedWrapper> {
  StreamSubscription? _subscription;
  @override
  void initState() {
    super.initState();

    _subscription = widget.device.connectionState.listen((state) {
      if (state == BLEConnectionState.disconnected) {
        //widget.device.disconnect();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DashboardMultiple(),
        //   ),
        //       (route) => false,
        // );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeimspeicherSystemProvider(
      device: widget.device,
      chunkSize: widget.chunkSize,
      child: Navigator(
        onGenerateRoute: (_) => CupertinoPageRoute(
          // builder: (_) => LandingPage(
          //   device: widget.device,
          // ),
          builder: (_) => SearchWiFiPage(device: widget.device,),
        ),
      ),
    );
  }
}
