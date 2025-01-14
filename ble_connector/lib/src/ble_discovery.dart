import 'package:ble_connector/ble_connector.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

/// @template ble_discovery
/// A single-purpose object for discovery of BLE devices
/// @endtemplate
class BLEDiscovery {
  /// @macro ble_discovery
  BLEDiscovery({
    BLEWrapper? ble,
  }) : _ble = ble ?? BLEWrapper();

  final BLEWrapper _ble;
  final _log = Logger();

  /// Discover Devices
  ///
  /// If [withServiceUuids] is provided, returns only devices
  /// that advertise all given Uuids
  Stream<BLEDeviceAdvertInfo> discover({
    List<String>? withServiceUuids,
  }) {
    return Rx.defer(
      () => Stream.fromFuture(_ble.checkHostBleStatus()).switchMap(
        (_) {
          return _ble
              .scan(withServiceUuids: withServiceUuids)
              .doOnData((results) {
            _log.d('Bluetooth Scan Results: $results');
          });
        },
      ),
    );
  }
}
