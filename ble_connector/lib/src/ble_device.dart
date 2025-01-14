import 'dart:async';

import 'package:ble_connector/src/ble_implementation_wrapper/ble_wrapper.dart';
import 'package:ble_connector/src/model/ble_device_endpoint.dart';
import 'package:ble_connector/src/model/model.dart';
import 'package:rxdart/rxdart.dart';

/// @template ble_device
/// Represents a single Bluetooth Device
/// @endtemplate
class BLEDevice {
  /// @macro ble_device
  BLEDevice({
    required BLEWrapper ble,
    required String deviceId,
    String deviceName = '',
  })  : _deviceName = deviceName,
        _ble = ble,
        _deviceId = deviceId;

  factory BLEDevice.fromAdvertisement({
    required BLEDeviceAdvertInfo info,
    BLEWrapper? ble,
  }) {
    return BLEDevice(
      ble: ble ?? BLEWrapper(),
      deviceId: info.id,
      deviceName: info.name,
    );
  }

  final BLEWrapper _ble;
  final String _deviceId;
  String get id => _deviceId;
  final String _deviceName;
  String get name => _deviceName;

  StreamSubscription<BLEConnectionState>? _connectionStateSubscription;

  final _connectionState = BehaviorSubject<BLEConnectionState>.seeded(
    BLEConnectionState.disconnected,
  );

  /// Shows the current [BLEConnectionState] of the device
  ValueStream<BLEConnectionState> get connectionState =>
      _connectionState.stream;

  /// Connect to the device
  ///
  /// If the device is already connected, it is disconnected frist.
  ///
  /// Before connecting, the host BLE status is checked.
  /// Throws a [HostBLENotReadyException] if the host BLE is not ready.
  Future<void> connect() async {
    await _ble.checkHostBleStatus();

    await _connectionStateSubscription?.cancel();

    _connectionStateSubscription = _ble
        .connectTo(_deviceId)
        .where((update) => update.deviceId == _deviceId)
        .map((update) => update.connectionState)
        .listen(_connectionState.add);
  }

  /// Disconnect the device
  Future<void> disconnect() async {
    _connectionState.add(BLEConnectionState.disconnected);

    await _connectionStateSubscription?.cancel();
  }

  Future<List<int>> read(BLEEndpoint endpoint) async {
    await _ble.checkHostBleStatus();
    return _ble.read(
      endpoint: BLEDeviceEndpoint.fromBleEndpoint(
        deviceId: _deviceId,
        endpoint: endpoint,
      ),
    );
  }

  /// Write data to the given [BLEEndpoint] of the device with response
  ///
  /// Before writing, the host BLE status is checked.
  /// Throws a [HostBLENotReadyException] if the host BLE is not ready.
  Future<void> writeWithResponse({
    required List<int> data,
    required BLEEndpoint endpoint,
  }) async {
    await _ble.checkHostBleStatus();
    await _ble.writeWithResponse(
      endpoint: BLEDeviceEndpoint.fromBleEndpoint(
        deviceId: _deviceId,
        endpoint: endpoint,
      ),
      data: data,
    );
  }

  /// Subscribes to the given [BLEEndpoint] of the device
  ///
  /// Before subscribing, the host BLE status is checked.
  /// Throws a [HostBLENotReadyException] if the host BLE is not ready.
  Stream<List<int>> subscribe(
    BLEEndpoint endpoint,
  ) {
    return Rx.defer(
      () => Stream.fromFuture(_ble.checkHostBleStatus()).switchMap(
        (_) => _ble.subscribe(
          endpoint: BLEDeviceEndpoint.fromBleEndpoint(
            deviceId: _deviceId,
            endpoint: endpoint,
          ),
        ),
      ),
    );
  }

  Future<int> requestMtu({int mtu = 512}) {
    return _ble.requestMtu(_deviceId, mtu: mtu);
  }
}
