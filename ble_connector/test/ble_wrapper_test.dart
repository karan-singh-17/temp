// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:typed_data';

import 'package:ble_connector/ble_connector.dart';
import 'package:ble_connector/src/model/ble_device_endpoint.dart';
import 'package:ble_connector/src/model/ble_status.dart';
import 'package:ble_connector/src/model/device_connection_update.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart'
    as flutter_reactive_ble;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockFlutterReactiveBle extends Mock
    implements flutter_reactive_ble.FlutterReactiveBle {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final discoveredDevice1 = flutter_reactive_ble.DiscoveredDevice(
    id: 'dev1',
    name: 'name1',
    serviceData: const {},
    manufacturerData: Uint8List.fromList([]),
    rssi: 0,
    serviceUuids: const [],
  );

  final discoveredDevice2 = flutter_reactive_ble.DiscoveredDevice(
    id: 'dev2',
    name: 'name2',
    serviceData: const {},
    manufacturerData: Uint8List.fromList([]),
    rssi: 0,
    serviceUuids: const [],
  );

  final discoveredDevice3 = flutter_reactive_ble.DiscoveredDevice(
    id: 'dev3',
    name: 'name3',
    serviceData: const {},
    manufacturerData: Uint8List.fromList([]),
    rssi: 0,
    serviceUuids: const [],
  );

  final endpoint = BLEDeviceEndpoint(
    characteristicUuid: Uuid().v1(),
    serviceUuid: Uuid().v1(),
    deviceId: 'deviceId',
  );

  final bleDeviceAdvertInfo = BLEDeviceAdvertInfo(name: 'name1', id: 'id1');

  late flutter_reactive_ble.FlutterReactiveBle frb;
  late BLEWrapper wrapper;

  setUpAll(() {
    registerFallbackValue(
      flutter_reactive_ble.QualifiedCharacteristic(
        characteristicId: flutter_reactive_ble.Uuid.parse(Uuid().v1()),
        serviceId: flutter_reactive_ble.Uuid.parse(Uuid().v1()),
        deviceId: 'device',
      ),
    );
  });

  setUp(() {
    frb = MockFlutterReactiveBle();
    wrapper = BLEWrapper(
      flutterReactiveBle: frb,
      checkHostBleTimeout: Duration(milliseconds: 300),
    );
  });
  group('BLEWrapper', () {
    test('can be instantiated', () {
      expect(BLEWrapper(flutterReactiveBle: frb), isNotNull);
    });

    group('scan()', () {
      setUp(() {
        when(() => frb.scanForDevices(withServices: [])).thenAnswer(
          (invocation) => Stream.fromIterable([
            discoveredDevice1,
            discoveredDevice2,
            discoveredDevice1,
            discoveredDevice3,
            discoveredDevice2,
          ]),
        );
      });

      test('calls frb.scanForDevices', () {
        wrapper.scan();
        verify(() => frb.scanForDevices(withServices: []));
      });

      test('returns BleDevices as found by frb', () {
        expect(
          wrapper.scan(),
          emitsInOrder([
            BLEDeviceAdvertInfo(
              name: discoveredDevice1.name,
              id: discoveredDevice1.id,
            ),
            BLEDeviceAdvertInfo(
              name: discoveredDevice2.name,
              id: discoveredDevice2.id,
            ),
            BLEDeviceAdvertInfo(
              name: discoveredDevice1.name,
              id: discoveredDevice1.id,
            ),
            BLEDeviceAdvertInfo(
              name: discoveredDevice3.name,
              id: discoveredDevice3.id,
            ),
            BLEDeviceAdvertInfo(
              name: discoveredDevice2.name,
              id: discoveredDevice2.id,
            ),
          ]),
        );
      });
    });

    group('BleStatusStream', () {
      setUp(() {
        when(() => frb.statusStream).thenAnswer(
          (invocation) => Stream.fromIterable([
            flutter_reactive_ble.BleStatus.unknown,
            flutter_reactive_ble.BleStatus.poweredOff,
            flutter_reactive_ble.BleStatus.ready,
          ]),
        );
      });
      test('emits ble status from frb', () {
        expect(
          wrapper.statusStream,
          emitsInOrder([
            BLEStatus.unknown,
            BLEStatus.poweredOff,
            BLEStatus.ready,
          ]),
        );
      });
    });

    group('connectTo()', () {
      setUp(() {
        when(() => frb.connectToDevice(id: any(named: 'id'))).thenAnswer(
          (invocation) => Stream.value(
            flutter_reactive_ble.ConnectionStateUpdate(
              deviceId: 'id',
              connectionState:
                  flutter_reactive_ble.DeviceConnectionState.connecting,
              failure: null,
            ),
          ),
        );
      });
      test('calls frb.connectToDevice()', () {
        wrapper.connectTo(bleDeviceAdvertInfo.id);
        verify(() => frb.connectToDevice(id: bleDeviceAdvertInfo.id));
      });

      test('emits ConnectionStateUpdates as received from frb', () {
        expect(
          wrapper.connectTo(bleDeviceAdvertInfo.id),
          emits(
            DeviceConnectionUpdate(
              deviceId: 'id',
              connectionState: BLEConnectionState.connecting,
            ),
          ),
        );
      });
    });

    group('writeWithResponse()', () {
      setUp(() {
        when(
          () => frb.writeCharacteristicWithResponse(
            any(),
            value: any(named: 'value'),
          ),
        ).thenAnswer((invocation) => Future.value());
      });
      test('calls frb.writeWithResponse', () {
        wrapper.writeWithResponse(endpoint: endpoint, data: []);
        verify(
          () => frb.writeCharacteristicWithResponse(
            any(),
            value: any(named: 'value'),
          ),
        );
      });
    });

    group('read()', () {
      setUp(() {
        when(() => frb.readCharacteristic(any()))
            .thenAnswer((invocation) => Future.value([]));
      });
      test('calls frb.readCharacteristic', () {
        wrapper.read(endpoint: endpoint);
        verify(() => frb.readCharacteristic(any()));
      });
    });

    group('subscribe()', () {
      setUp(() {
        when(() => frb.subscribeToCharacteristic(any()))
            .thenAnswer((invocation) => Stream.value([]));
      });
      test('calls frb.readCharacteristic', () {
        wrapper.subscribe(endpoint: endpoint);
        verify(() => frb.subscribeToCharacteristic(any()));
      });
    });

    group('getServices()', () {
      late List<FrbService> frbServices;

      setUpAll(() {
        final char1 =
            FrbCharacteristic(id: '33502ab2-7d41-11ee-b962-0242ac120002');
        final char2 =
            FrbCharacteristic(id: '9543f1da-7d42-11ee-b962-0242ac120002');

        final serv1 = FrbService(
          deviceId: 'id',
          id: 'dcef5eee-47f2-4275-a072-c63205ec9400',
          characteristics: [char1, char2],
        );

        char1.setService(serv1);
        char2.setService(serv1);
        frbServices = [serv1];

        registerFallbackValue('deviceId');
      });

      setUp(() {
        when(() => frb.discoverAllServices(any()))
            .thenAnswer((invocation) => Future.value());

        when(() => frb.getDiscoveredServices(any()))
            .thenAnswer((invocation) => Future.value(frbServices));
      });

      test('discovers all services on the device', () async {
        await wrapper.getServices(discoveredDevice1.id);
        verify(() => frb.discoverAllServices(discoveredDevice1.id));
      });

      test('requests all services on the device', () async {
        await wrapper.getServices(discoveredDevice1.id);
        verify(() => frb.getDiscoveredServices(discoveredDevice1.id));
      });

      test(
          'returns all services and characteristics all services on the device',
          () async {
        final services = await wrapper.getServices(discoveredDevice1.id);
        expect(services, [
          Service(
            uuid: 'dcef5eee-47f2-4275-a072-c63205ec9400',
            characteristics: [
              Characteristic(
                uuid: '33502ab2-7d41-11ee-b962-0242ac120002',
                isReadable: false,
                isWritableWithoutResponse: false,
                isWritableWithResponse: false,
                isNotifiable: false,
                isIndicatable: false,
              ),
              Characteristic(
                uuid: '9543f1da-7d42-11ee-b962-0242ac120002',
                isReadable: false,
                isWritableWithoutResponse: false,
                isWritableWithResponse: false,
                isNotifiable: false,
                isIndicatable: false,
              ),
            ],
          ),
        ]);
      });
    });

    group('CheckHostBleStatus', () {
      late StreamController<flutter_reactive_ble.BleStatus> statusStream;

      setUp(() {
        statusStream = StreamController();
        when(() => frb.statusStream).thenAnswer(
          (invocation) => statusStream.stream,
        );
      });

      tearDown(() async {
        await Future<void>.delayed(Duration(milliseconds: 10));
        await statusStream.close();
      });

      test(
          'Waits the given Duration '
          'when Host BLE is powered off', () async {
        statusStream.add(flutter_reactive_ble.BleStatus.poweredOff);

        final timer = Stopwatch()..start();
        try {
          await wrapper.checkHostBleStatus();
        } catch (_) {}

        expect(
          timer.elapsed,
          greaterThanOrEqualTo(Duration(milliseconds: 300)),
        );
      });

      test(
          'Waits the given Duration '
          'when Host BLE is unknown', () async {
        statusStream.add(flutter_reactive_ble.BleStatus.unknown);

        final timer = Stopwatch()..start();
        try {
          await wrapper.checkHostBleStatus();
        } catch (_) {}

        expect(
          timer.elapsed,
          greaterThanOrEqualTo(Duration(milliseconds: 300)),
        );
      });

      test(
          'throws a BHostBleNotReadyException '
          'when Host BLE is poweredOff', () async {
        statusStream.add(flutter_reactive_ble.BleStatus.poweredOff);

        expect(
          () async => wrapper.checkHostBleStatus(),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });

      test(
          'throws a BHostBleNotReadyException '
          'when Host BLE is unknown', () async {
        statusStream.add(flutter_reactive_ble.BleStatus.unknown);

        expect(
          () async => wrapper.checkHostBleStatus(),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });
      test(
          'throws a BHostBleNotReadyException '
          'when Host BLE is unsupported', () async {
        statusStream.add(flutter_reactive_ble.BleStatus.unsupported);

        expect(
          () async => wrapper.checkHostBleStatus(),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });
      test(
          'throws a BHostBleNotReadyException '
          'when Host BLE is unauthorized', () async {
        statusStream.add(flutter_reactive_ble.BleStatus.unauthorized);

        expect(
          () async => wrapper.checkHostBleStatus(),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });

      test(
          'throws a BHostBleNotReadyException '
          'when Host location services are disabled', () async {
        statusStream.add(
          flutter_reactive_ble.BleStatus.locationServicesDisabled,
        );

        expect(
          () async => wrapper.checkHostBleStatus(),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });
    });

    group('RequestMtu()', () {
      setUp(() {
        when(
          () => frb.requestMtu(
            deviceId: any(named: 'deviceId'),
            mtu: any(named: 'mtu'),
          ),
        ).thenAnswer((invocation) {
          final mtu = invocation.namedArguments[Symbol('mtu')] as int;

          return Future.value(mtu.clamp(23, 512));
        });
      });

      void verifyMTURequested(int mtu) {
        verify(() => frb.requestMtu(deviceId: discoveredDevice1.id, mtu: mtu));
      }

      test('returns negotiated MTU from frb.requestMtu with 512 as default mtu',
          () async {
        expect(
          await wrapper.requestMtu(discoveredDevice1.id),
          512,
        );

        verifyMTURequested(512);
      });

      test(
          'returns negotiated MTU from frb.requestMtu requesting the '
          'provided MTU', () async {
        expect(
          await wrapper.requestMtu(discoveredDevice1.id, mtu: 100),
          100,
        );

        verifyMTURequested(100);
      });
    });
  });
}

class FrbCharacteristic implements flutter_reactive_ble.Characteristic {
  FrbCharacteristic({required String id})
      : _id = flutter_reactive_ble.Uuid.parse(id);

  final flutter_reactive_ble.Uuid _id;
  late flutter_reactive_ble.Service _service;

  // ignore: use_setters_to_change_properties
  void setService(FrbService s) => _service = s;

  @override
  flutter_reactive_ble.Uuid get id => _id;

  @override
  flutter_reactive_ble.Service get service => _service;

  @override
  bool get isIndicatable => false;

  @override
  bool get isNotifiable => false;

  @override
  bool get isReadable => false;

  @override
  bool get isWritableWithResponse => false;

  @override
  bool get isWritableWithoutResponse => false;

  @override
  Future<List<int>> read() {
    throw UnimplementedError();
  }

  @override
  Stream<List<int>> subscribe() {
    throw UnimplementedError();
  }

  @override
  Future<void> write(List<int> value, {bool withResponse = true}) {
    throw UnimplementedError();
  }
}

class FrbService implements flutter_reactive_ble.Service {
  FrbService({
    required String deviceId,
    required String id,
    required List<FrbCharacteristic> characteristics,
  })  : _deviceId = deviceId,
        _id = flutter_reactive_ble.Uuid.parse(id),
        _characteristics = characteristics;

  final String _deviceId;
  final flutter_reactive_ble.Uuid _id;
  final List<FrbCharacteristic> _characteristics;

  @override
  List<flutter_reactive_ble.Characteristic> get characteristics =>
      _characteristics;

  @override
  String get deviceId => _deviceId;

  @override
  flutter_reactive_ble.Uuid get id => _id;
}
