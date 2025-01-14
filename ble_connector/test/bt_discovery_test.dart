// ignore_for_file: prefer_const_constructors

import 'package:ble_connector/ble_connector.dart';
import 'package:ble_connector/src/model/ble_device_endpoint.dart';
import 'package:ble_connector/src/model/ble_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBLEWrapper extends Mock implements BLEWrapper {}

void main() {
  final device1 = BLEDeviceAdvertInfo(name: 'device1', id: 'id1');
  final device2 = BLEDeviceAdvertInfo(name: 'device2', id: 'id2');
  final device3 = BLEDeviceAdvertInfo(name: 'device3', id: 'id3');
  final characteristic = BLEEndpoint(
    characteristicUuid: '',
    serviceUuid: '',
  );
  final endpoint = BLEDeviceEndpoint(
    characteristicUuid: '',
    serviceUuid: '',
    deviceId: '',
  );

  late MockBLEWrapper wrapper;
  late BLEDiscovery discovery;

  setUpAll(() {
    registerFallbackValue(device1);
    registerFallbackValue(characteristic);
    registerFallbackValue(endpoint);
  });

  void setupHostBleStatus({BLEStatus status = BLEStatus.ready}) {
    if (status == BLEStatus.ready) {
      when(() => wrapper.checkHostBleStatus())
          .thenAnswer((invocation) => Future.value());
      return;
    }

    when(() => wrapper.checkHostBleStatus()).thenThrow(
      HostBLENotReadyException(
        userDescription: '',
        lastBleStatus: status,
      ),
    );
  }

  setUp(() {
    wrapper = MockBLEWrapper();
    discovery = BLEDiscovery(ble: wrapper);
    setupHostBleStatus();
  });

  group('BleDiscovery', () {
    group('discover()', () {
      setUp(() {
        when(
          () => wrapper.scan(
            withServiceUuids: any(named: 'withServiceUuids'),
          ),
        ).thenAnswer(
          (invocation) => Stream.fromIterable(
            [
              device1,
              device2,
              device1,
              device3,
              device1,
            ],
          ),
        );
      });

      test('emits an error, when HostBLE is not ready', () {
        setupHostBleStatus(status: BLEStatus.unauthorized);

        expect(
          discovery.discover(),
          emitsError(isA<BLEException>()),
        );
      });

      test('calls wrapper.scan()', () async {
        discovery.discover().listen((event) {});
        await Future<void>.delayed(Duration(milliseconds: 10));
        verify(() => wrapper.scan());
      });

      test('returns discovered devices', () {
        expect(
          discovery.discover(),
          emitsInOrder(
            [
              device1,
              device2,
              device1,
              device3,
              device1,
            ],
          ),
        );
      });
    });
  });
}
