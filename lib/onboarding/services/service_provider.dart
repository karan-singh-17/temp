import 'package:moe/onboarding/services/ble_provider.dart';
import 'package:moe/onboarding/services/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ServiceProvider extends SingleChildStatelessWidget {
  const ServiceProvider({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiProvider(
      providers: const [
        BleConnectorProvider(),
        // const BleWrapperProvider(),
        SettingsServiceProvider(),
        // Required a BLEDemoDevice
        // const HeimspeicherProvider(),
        //  HeimspeicherSystemProvider  ()
      ],
      child: child,
    );
  }
}
