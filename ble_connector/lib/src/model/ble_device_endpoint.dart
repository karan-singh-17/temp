import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/foundation.dart';

/// {@template ble_endpoint}
/// Ble endpoint describing a specific Service and Characteristic on a
/// specific device
/// {@endtemplate}
@immutable
class BLEDeviceEndpoint extends BLEEndpoint {
  /// {@macro ble_endpoint}
  BLEDeviceEndpoint({
    required this.deviceId,
    required super.characteristicUuid,
    required super.serviceUuid,
  });

  BLEDeviceEndpoint.fromBleEndpoint({
    required String deviceId,
    required BLEEndpoint endpoint,
  }) : this(
          characteristicUuid: endpoint.characteristicUuid,
          serviceUuid: endpoint.serviceUuid,
          deviceId: deviceId,
        );

  final DeviceId deviceId;

  @override
  List<Object?> get props => [characteristicUuid, serviceUuid, deviceId];
}
