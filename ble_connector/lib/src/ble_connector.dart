import 'package:ble_connector/ble_connector.dart';

/// {@template ble_connector}
/// A Facade to the [BLEDiscovery] and [BLEDevice] that ensures every object
/// created uses the same [BLEWrapper] provided in the constructor.
/// {@endtemplate}
class BLEConnector {
  /// {@macro ble_connector}
  BLEConnector({
    BLEWrapper? ble,
  }) : _ble = ble ?? BLEWrapper();

  final BLEWrapper _ble;

  /// A [BLEDiscovery] that uses the [BLEWrapper] provided in the constructor.
  late final BLEDiscovery discoverer = BLEDiscovery(ble: _ble);

  /// Creates a [BLEDevice] that uses the [BLEWrapper] provided in the
  /// constructor of the [BLEConnector].
  BLEDevice deviceFromAdvertInfo({
    required BLEDeviceAdvertInfo info,
  }) =>
      BLEDevice.fromAdvertisement(
        info: info,
        ble: _ble,
      );

  /// Creates a [BLEDevice] that uses the [BLEWrapper] provided in the
  /// constructor of the [BLEConnector].
  BLEDevice deviceFromId({
    required DeviceId id,
    String name = '',
  }) {
    return BLEDevice(
      deviceId: id,
      deviceName: name,
      ble: _ble,
    );
  }
}
