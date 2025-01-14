// ignore_for_file: prefer_const_constructors

import 'package:ble_connector/ble_connector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBLEWrapper extends Mock implements BLEWrapper {}

void main() {
  late MockBLEWrapper bt;
  late BLEConnector connector;

  setUp(() {
    bt = MockBLEWrapper();
    connector = BLEConnector(ble: bt);

    when(() => bt.checkHostBleStatus())
        .thenAnswer((invocation) => Future.value());
  });
  group('BLEConnector', () {
    test('can be instanciated', () {
      expect(
        BLEConnector(ble: bt),
        isNotNull,
      );
    });

    group('discoverer', () {
      setUpAll(() {
        registerFallbackValue(<String>[]);
      });
      setUp(() {
        when(() => bt.scan(withServiceUuids: any(named: 'withServiceUuids')))
            .thenAnswer(
          (invocation) => Stream.empty(),
        );
      });

      test('returns a discoverer that uses the given bleWrapper ', () async {
        connector.discoverer.discover().listen((event) {});
        verify(() => bt.checkHostBleStatus());
      });
    });

    group('deviceFromAdvertInfo()', () {
      setUpAll(() {
        registerFallbackValue('id');
      });
      setUp(() {
        when(() => bt.connectTo(any()))
            .thenAnswer((invocation) => Stream.empty());

        when(() => bt.getServices(any()))
            .thenAnswer((invocation) => Future.value([]));
      });
      test('creates Devices that use the given bleWrapper', () async {
        final info = BLEDeviceAdvertInfo(name: 'name', id: 'id');
        final device = connector.deviceFromAdvertInfo(info: info);
        await device.connect();
        verify(() => bt.connectTo(any()));
      });
    });

    group('deviceFromId()', () {
      setUpAll(() {
        registerFallbackValue('id');
      });
      setUp(() {
        when(() => bt.connectTo(any()))
            .thenAnswer((invocation) => Stream.empty());

        when(() => bt.getServices(any()))
            .thenAnswer((invocation) => Future.value([]));
      });
      test('creates Devices that use the given bleWrapper', () async {
        final device = connector.deviceFromId(id: 'id');
        await device.connect();
        verify(() => bt.connectTo(any()));
      });
    });
  });
}
