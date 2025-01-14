import 'package:ble_connector/ble_connector.dart';
import 'package:equatable/equatable.dart';

class DeviceConnectionUpdate extends Equatable {
  const DeviceConnectionUpdate({
    required this.deviceId,
    required this.connectionState,
    this.failure,
  });

  final DeviceId deviceId;

  final BLEConnectionState connectionState;

  /// Field `failure` is null if there is no error reported.
  final ConnectionError? failure;

  @override
  List<Object?> get props => [deviceId, connectionState, failure];
}
