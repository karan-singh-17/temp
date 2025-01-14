import 'package:ble_connector/ble_connector.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// Connection status.
enum BLEConnectionState {
  /// Currently establishing a connection.
  @JsonValue(0)
  connecting,

  /// Connection is established.
  @JsonValue(1)
  connected,

  /// Terminating the connection.
  @JsonValue(2)
  disconnecting,

  /// Device is disconnected.
  @JsonValue(3)
  disconnected
}

/// A [BLEConnectionState] with added information about the device related
/// to the state
@immutable
class BLEDeviceState extends Equatable {
  const BLEDeviceState({
    required this.state,
    required this.deviceName,
    required this.deviceId,
  });

  BLEDeviceState.fromDevice({
    required this.state,
    required BLEDevice? device,
  })  : deviceName = device == null ? '' : device.name,
        deviceId = device == null ? '' : device.id;

  final BLEConnectionState state;
  final String deviceName;
  final String deviceId;

  @override
  List<Object?> get props => [
        state,
        deviceName,
        deviceId,
      ];
}
