import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// {@template ble_endpoint}
/// Ble endpoint describing a Service - Characteristic pair
/// {@endtemplate}
@immutable
class BLEEndpoint extends Equatable {
  BLEEndpoint({
    required String serviceUuid,
    required String characteristicUuid,
  })  : characteristicUuid = characteristicUuid.toLowerCase(),
        serviceUuid = serviceUuid.toLowerCase();

  final String characteristicUuid;

  final String serviceUuid;

  @override
  List<Object?> get props => [characteristicUuid, serviceUuid];

  @override
  String toString() {
    return 'BleEndpoint { characteristicUuid: $characteristicUuid, '
        'serviceUuid: $serviceUuid }';
  }
}
