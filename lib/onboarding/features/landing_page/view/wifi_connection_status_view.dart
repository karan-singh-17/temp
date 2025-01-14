import 'package:moe/onboarding/features/landing_page/widget/connection_indicator_square.dart';
import 'package:moe/onboarding/util/value_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';

class WifiConnectionStatusView extends StatelessWidget {
  const WifiConnectionStatusView({
    this.displayConnectionWithText = false,
    super.key,
  });

  final bool displayConnectionWithText;

  static Color stateColor(WiFiStatus status) {
    switch (status) {
      case WiFiStatus.connected:
        return Colors.green.shade600;
      case WiFiStatus.connecting:
        return Colors.green.shade200;
      case WiFiStatus.disconnected:
        return Colors.red.shade600;
      case WiFiStatus.scanning:
        return Colors.yellow.shade800;
      case WiFiStatus.unknown:
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
        stream: context.read<HeimspeicherSystem>().wifiStatusStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Placeholder();
          }

          final data = snapshot.data!;

          return ConnectionIndicatorSquare(
            color: stateColor(data),
          );
        });
  }
}
