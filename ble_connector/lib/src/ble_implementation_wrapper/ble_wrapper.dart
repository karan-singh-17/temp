import 'package:ble_connector/ble_connector.dart';
import 'package:ble_connector/src/ble_implementation_wrapper/converter_extensions.dart';
import 'package:ble_connector/src/model/ble_device_endpoint.dart';
import 'package:ble_connector/src/model/ble_status.dart';
import 'package:ble_connector/src/model/device_connection_update.dart';
import 'package:ble_connector/src/model/model.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as frb;
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

/// {@template ble_wrapper}
/// A wrapper around Flutter Reactive Ble with some conveniance functions
/// {@endtemplate}
class BLEWrapper {
  /// {@macro ble_wrapper}
  BLEWrapper({
    frb.FlutterReactiveBle? flutterReactiveBle,
    Duration? checkHostBleTimeout,
  })  : _frb = flutterReactiveBle ?? frb.FlutterReactiveBle(),
        _checkHostBleTimeout =
            checkHostBleTimeout ?? const Duration(seconds: 3);

  final frb.FlutterReactiveBle _frb;
  final Logger _log = Logger();
  final Duration _checkHostBleTimeout;

  /// Wrapper around [frb.FlutterReactiveBle.statusStream]
  Stream<BLEStatus> get statusStream =>
      _frb.statusStream.map((i) => i.toBleStatus());

  /// Wrapper around [frb.FlutterReactiveBle.scanForDevices]
  Stream<BLEDeviceAdvertInfo> scan({List<String>? withServiceUuids}) {
    _log.d('Scanning for Devices with Services: ${withServiceUuids ?? 'any'}');
    return _frb
        .scanForDevices(
          withServices:
              withServiceUuids?.map((e) => e.toFrbUuid()).toList() ?? [],
        )
        .map((d) => d.toBleDeviceAdvertInfo());
  }

  /// Wrapper around [frb.FlutterReactiveBle.connectToDevice]
  Stream<DeviceConnectionUpdate> connectTo(DeviceId deviceId) => _frb
      .connectToDevice(id: deviceId)
      .map((i) => i.toDeviceConnectionUpdate());

  /// Wrapper around [frb.FlutterReactiveBle.writeCharacteristicWithResponse]
  Future<void> writeWithResponse({
    required BLEDeviceEndpoint endpoint,
    required List<int> data,
  }) async {
    return _frb.writeCharacteristicWithResponse(
      endpoint.toQualifiedCharacteristic(),
      value: data,
    );
  }

  /// Wrapper around [frb.FlutterReactiveBle.readCharacteristic]
  Future<List<int>> read({
    required BLEDeviceEndpoint endpoint,
  }) async {
    return _frb.readCharacteristic(
      endpoint.toQualifiedCharacteristic(),
    );
  }

  /// Wrapper around [frb.FlutterReactiveBle.subscribeToCharacteristic]
  Stream<List<int>> subscribe({
    required BLEDeviceEndpoint endpoint,
  }) {
    return _frb
        .subscribeToCharacteristic(
      endpoint.toQualifiedCharacteristic(),
    )
        .doOnData((data) {
      _log.d('Received notification from endpoint: $endpoint; data: $data');
    });
  }

  /// Discovers all [Service]s and their [Characteristic]s
  Future<List<Service>> getServices(DeviceId deviceId) async {
    await _frb.discoverAllServices(deviceId);
    final allServices = await _frb.getDiscoveredServices(deviceId);
    return allServices.map((s) => s.toService()).toList();
  }

  /// Checks whether the Host BLE is ready
  ///
  /// When Host BLE is not ready and no state changes are detected
  /// for 3 seconds, throws a [HostBLENotReadyException]
  Future<void> checkHostBleStatus() async {
    final status = await statusStream.debounce((event) {
      if (event == BLEStatus.unknown || event == BLEStatus.poweredOff) {
        return TimerStream(true, _checkHostBleTimeout);
      }
      return const Stream<void>.empty();
    }).first;

    switch (status) {
      case BLEStatus.ready:
        _log.d('Host BLE is ready');
        return;
      case BLEStatus.unknown:
        throw const HostBLENotReadyException(
          userDescription: 'Bluetooth can not be found on your device. '
              'Is Bluetooth enabled?',
          lastBleStatus: BLEStatus.unknown,
        );
      case BLEStatus.unsupported:
        throw const HostBLENotReadyException(
          userDescription: 'Your device does not support Bluetooth',
          lastBleStatus: BLEStatus.unsupported,
        );
      case BLEStatus.unauthorized:
        throw const HostBLENotReadyException(
          userDescription: 'Please allow this app to use bluetooth.',
          lastBleStatus: BLEStatus.unauthorized,
        );
      case BLEStatus.poweredOff:
        throw const HostBLENotReadyException(
          userDescription: 'Bluetooth is not enabled on your device.',
          lastBleStatus: BLEStatus.poweredOff,
        );
      case BLEStatus.locationServicesDisabled:
        throw const HostBLENotReadyException(
          userDescription: 'This App requires location services to be enabled',
          lastBleStatus: BLEStatus.locationServicesDisabled,
        );
    }
  }

  /// Request an MTU
  Future<int> requestMtu(DeviceId deviceId, {int mtu = 512}) async {
    return _frb.requestMtu(deviceId: deviceId, mtu: mtu);
  }
}
