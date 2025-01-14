import 'package:moe/onboarding/model/model.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class BleConnectorProvider extends SingleChildStatelessWidget {
  const BleConnectorProvider({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Provider(
      create: (_) => BLEConnector(),
      child: child,
    );
  }
}

class BleWrapperProvider extends SingleChildStatelessWidget {
  const BleWrapperProvider({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Provider(
      create: (_) => BLEWrapper(),
      child: child,
    );
  }
}

const Setting<DeviceId?> selectedBLEDeviceIDSetting = Setting(
  key: 'selectedBLEDeviceID',
  defaultValue: null,
);

const Setting<DeviceId?> selectedBLEDeviceNameSetting = Setting(
  key: 'selectedBLEDeviceName',
  defaultValue: null,
);
