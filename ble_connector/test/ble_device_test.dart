// ignore_for_file: prefer_single_quotes, prefer_const_constructors

import 'package:ble_connector/src/ble_device.dart';
import 'package:ble_connector/src/ble_implementation_wrapper/ble_wrapper.dart';
import 'package:ble_connector/src/model/ble_device_endpoint.dart';
import 'package:ble_connector/src/model/ble_status.dart';
import 'package:ble_connector/src/model/device_connection_update.dart';
import 'package:ble_connector/src/model/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class MockBleWrapper extends Mock implements BLEWrapper {}

void main() {
  group('BLEDevice', () {
    const deviceId = 'deviceId';
    const data = [1, 2, 3];

    final endpoint =
        BLEEndpoint(characteristicUuid: "char", serviceUuid: "serv");

    var connectionStreamCanceled = false;
    late PublishSubject<DeviceConnectionUpdate> connectionStream;
    late BLEWrapper ble;
    late BLEDevice device;

    final deviceEndpoint = BLEDeviceEndpoint.fromBleEndpoint(
      deviceId: deviceId,
      endpoint: endpoint,
    );

    void setUpBleWrapper() {
      connectionStreamCanceled = false;
      connectionStream = PublishSubject(
        onCancel: () => connectionStreamCanceled = true,
      );
      ble = MockBleWrapper();

      when(() => ble.connectTo(deviceId)).thenAnswer((_) => connectionStream);
      when(() => ble.checkHostBleStatus()).thenAnswer((_) async {});
    }

    Future<void> setConnectionStateOfDevice(
      BLEConnectionState state,
      String deviceId,
    ) async {
      connectionStream.add(
        DeviceConnectionUpdate(
          deviceId: deviceId,
          connectionState: state,
        ),
      );
      await Future<void>.delayed(Duration.zero);
    }

    Future<void> setConnectionState(BLEConnectionState state) async =>
        setConnectionStateOfDevice(state, deviceId);

    setUp(() {
      setUpBleWrapper();

      device = BLEDevice(
        ble: ble,
        deviceId: deviceId,
      );
    });

    Stream<BLEConnectionState> connectionStateWithoutInitialValue() {
      return device.connectionState.skip(1);
    }

    test('can be instanciated', () {
      expect(
        device,
        isA<BLEDevice>(),
      );
    });

    group('connectionState', () {
      test('initial State is disconnected', () {
        expect(
          device.connectionState,
          emits(BLEConnectionState.disconnected),
        );
      });
    });

    group('connect()', () {
      setUp(() {
        when(() => ble.connectTo(deviceId)).thenAnswer((_) => connectionStream);
      });

      test('emits device connection states on connectionState Stream',
          () async {
        expect(
          connectionStateWithoutInitialValue(),
          emitsInOrder([
            BLEConnectionState.connecting,
            BLEConnectionState.connected,
          ]),
        );

        await device.connect();

        await setConnectionState(BLEConnectionState.connecting);
        await setConnectionState(BLEConnectionState.connected);
      });

      test('does not emit device connection states of other devices', () async {
        expect(
          connectionStateWithoutInitialValue(),
          emits(BLEConnectionState.disconnecting),
        );

        await device.connect();

        await setConnectionStateOfDevice(
          BLEConnectionState.connecting,
          '$deviceId-WRONG',
        );
        await setConnectionStateOfDevice(
          BLEConnectionState.connected,
          '$deviceId-WRONG',
        );

        await setConnectionState(BLEConnectionState.disconnecting);
      });

      test('throws an Error, if host BLE is not ready', () async {
        when(() => ble.checkHostBleStatus()).thenThrow(
          HostBLENotReadyException(
            userDescription: 'description',
            lastBleStatus: BLEStatus.unauthorized,
          ),
        );

        expect(
          () async => device.connect(),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });

      test('Cancels an existing ConnectionStreamSubscription', () async {
        // Setup existing connectionState Stream
        await device.connect();

        // Cancel existing Stream and create a new one
        await device.connect();

        expect(
          connectionStreamCanceled,
          isTrue,
        );
      });
    });

    group('disconnect()', () {
      setUp(() async {
        await device.connect();
        await setConnectionState(BLEConnectionState.connected);
      });

      test('sets the connection State to disconnected', () async {
        expect(
          connectionStateWithoutInitialValue(),
          emitsThrough(BLEConnectionState.disconnected),
        );

        await device.disconnect();
      });

      test('cancels the subscription to the connectionState', () async {
        expect(
          connectionStateWithoutInitialValue(),
          emitsThrough(BLEConnectionState.disconnected),
        );

        await device.disconnect();

        expect(
          connectionStreamCanceled,
          isTrue,
        );
      });
    });

    group('Read()', () {
      setUp(() async {
        await device.connect();
        await setConnectionState(BLEConnectionState.connected);

        when(() => ble.read(endpoint: deviceEndpoint)).thenAnswer(
          (_) => Future.value(data),
        );
      });

      void verifyReadFromEndpoint(BLEEndpoint endpoint) {
        verify(
          () => ble.read(
            endpoint: deviceEndpoint,
          ),
        );
      }

      test('requests data from given entpoint and device ID', () async {
        await device.read(endpoint);
        verifyReadFromEndpoint(endpoint);
      });

      test('throws an Error, if HostBleStatus is not ready', () {
        when(() => ble.checkHostBleStatus()).thenThrow(
          HostBLENotReadyException(
            userDescription: 'description',
            lastBleStatus: BLEStatus.unauthorized,
          ),
        );

        expect(
          () async => device.read(endpoint),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });
    });

    group('writeWithResponse()', () {
      setUp(() async {
        when(
          () => ble.writeWithResponse(
            endpoint: deviceEndpoint,
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
      });

      void verifyDataWritten(List<int> data) {
        verify(
          () => ble.writeWithResponse(
            endpoint: deviceEndpoint,
            data: data,
          ),
        );
      }

      test('writes the given Data', () async {
        await device.writeWithResponse(
          data: data,
          endpoint: endpoint,
        );

        verifyDataWritten(data);
      });

      test('throws an Error, if HostBleStatus is not ready', () {
        when(() => ble.checkHostBleStatus()).thenThrow(
          HostBLENotReadyException(
            userDescription: 'description',
            lastBleStatus: BLEStatus.unauthorized,
          ),
        );

        expect(
          () async => device.writeWithResponse(endpoint: endpoint, data: data),
          throwsA(isA<HostBLENotReadyException>()),
        );
      });
    });

    group('Subscribe()', () {
      final data1 = [1];
      final data2 = [2];
      var subscriptionCanceled = false;
      late PublishSubject<List<int>> subsriberStream;

      setUp(() {
        subscriptionCanceled = false;
        subsriberStream = PublishSubject(
          onCancel: () => subscriptionCanceled = true,
        );

        when(() => ble.subscribe(endpoint: deviceEndpoint))
            .thenAnswer((_) => subsriberStream);
      });

      Future<void> emitSubscriptionData(List<int> data) async {
        await Future<void>.delayed(Duration.zero);
        subsriberStream.add(data);
        await Future<void>.delayed(Duration.zero);
      }

      test('returns values received from ble', () async {
        expect(
          device.subscribe(endpoint),
          emitsInOrder([
            data1,
            data2,
          ]),
        );

        await emitSubscriptionData(data1);
        await emitSubscriptionData(data2);
      });

      test('throws an Error, if HostBleStatus is not ready', () {
        when(() => ble.checkHostBleStatus()).thenThrow(
          HostBLENotReadyException(
            userDescription: 'description',
            lastBleStatus: BLEStatus.unauthorized,
          ),
        );

        expect(
          device.subscribe(endpoint),
          emitsError(isA<HostBLENotReadyException>()),
        );
      });

      test('cancels source stream when stream subscription is canceled',
          () async {
        final stream = device.subscribe(endpoint);
        final subscription = stream.listen(
          (event) {},
        );

        // Wait until the underlying stream is actually subscribed to
        // (Defered because of HostBleChekcing)
        await Future<void>.delayed(Duration.zero);

        await subscription.cancel();

        expect(
          subscriptionCanceled,
          isTrue,
        );
      });
    });

    group('RequestMTU()', () {
      setUp(() {
        when(() => ble.requestMtu(any(), mtu: any(named: 'mtu')))
            .thenAnswer((invocation) {
          final mtu = invocation.namedArguments[Symbol('mtu')] as int;
          return Future.value((mtu - 1).clamp(23, 512));
        });
      });

      void verifyMTURequested(int mtu) {
        verify(() => ble.requestMtu(deviceId, mtu: mtu));
      }

      test('returns the negotioated mtu', () async {
        expect(
          await device.requestMtu(mtu: 100),
          99,
        );

        verifyMTURequested(100);
      });
    });
  });
}
