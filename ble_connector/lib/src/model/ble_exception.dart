import 'package:ble_connector/src/model/ble_status.dart';
import 'package:flutter/foundation.dart';

/// Type of connection error.
enum ConnectionError {
  /// Connection failed for an unknown reason.
  unknown,

  /// An attempt to connect was made but it failed.
  failedToConnect,
}

/// {@template ble_exception}
/// Parent class for all BLE related exceptions.
/// {@endtemplate}
@immutable
abstract class BLEException implements Exception {
  /// {@macro ble_exception}
  const BLEException({
    required this.userDescription,
  });

  final String userDescription;
}

/// {@template host_ble_not_ready_exception}
/// Thrown when the check for the host BLE status fails.
/// {@endtemplate}
@immutable
class HostBLENotReadyException extends BLEException {
  /// {@macro host_ble_not_ready_exception}
  const HostBLENotReadyException({
    required super.userDescription,
    required this.lastBleStatus,
  });

  /// The last known BLE status before the exception was thrown.
  final BLEStatus lastBleStatus;
}
