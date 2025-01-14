import 'package:ble_communication/src/ble_raw_datastream_endpoint.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

class MockBLEDevice extends Mock implements BLEDevice {}

class TestFixture {
  final bleEndpoint = BLEEndpoint(characteristicUuid: '1', serviceUuid: '2');
  final MockBLEDevice _device;
  final BehaviorSubject<BLEConnectionState> _connectionState;
  final PublishSubject<List<int>> _notifyReceiveStream;

  late final BLERawDataStreamEndpoint _endpoint;

  MockBLEDevice get device => _device;
  BLERawDataStreamEndpoint get endpoint => _endpoint;

  TestFixture()
      : _device = MockBLEDevice(),
        _connectionState = BehaviorSubject.seeded(BLEConnectionState.connected),
        _notifyReceiveStream = PublishSubject() {
    _setUpDevice();

    _endpoint = BLERawDataStreamEndpoint(
      device: device,
      writeEndpoint: bleEndpoint,
    );
  }

  void _setUpDevice() {
    when(() => device.writeWithResponse(
        endpoint: bleEndpoint,
        data: any(named: 'data'))).thenAnswer((_) => Future.value());
    when(() => device.connectionState)
        .thenAnswer((invocation) => _connectionState.stream);

    registerFallbackValue(bleEndpoint);
    when(() => device.subscribe(any()))
        .thenAnswer((_) => _notifyReceiveStream.stream);
  }

  Future<void> setDeviceConnectionState(BLEConnectionState state) async {
    _connectionState.add(state);
    // Ensure state is set when continuing execution
    await Future.delayed(Duration.zero);
  }

  Future<void> verifyDataWritten(List<int> data) async {
    await Future.delayed(Duration.zero);
    verify(() => device.writeWithResponse(endpoint: bleEndpoint, data: data));
  }

  Future<void> verifyMultipleDataWrites(List<List<int>> data) {
    return Future.wait(data.map((d) => verifyDataWritten(d)));
  }

  void receiveData(List<int> data) {
    _notifyReceiveStream.add(data);
  }
}

void main() {
  group('BTRawDataStreamEndpoint', () {
    late TestFixture fixture;
    late BLERawDataStreamEndpoint endpoint;

    final data = [1, 2, 3];

    setUp(() {
      fixture = TestFixture();
      endpoint = fixture.endpoint;
    });

    test('can be instanciated', () {
      expect(
        endpoint,
        isA<BLERawDataStreamEndpoint>(),
      );
    });

    test('throws error on instanciation when bleDevice is not connected',
        () async {
      await fixture.setDeviceConnectionState(BLEConnectionState.disconnected);

      expect(
        () => BLERawDataStreamEndpoint(
          device: fixture.device,
          writeEndpoint: fixture.bleEndpoint,
        ),
        throwsArgumentError,
      );
    });

    group('receive', () {
      test('receives data from BLEDevice', () {
        expect(
          endpoint,
          emits(data),
        );

        fixture.receiveData(data);
      });

      test('closes stream when disconnected', () async {
        await fixture.setDeviceConnectionState(BLEConnectionState.disconnected);

        expect(
          endpoint,
          emitsDone,
        );
      });
    });

    group('StreamSink', () {
      group('add', () {
        test('write BLEDevice ', () async {
          endpoint.add(data);

          await fixture.verifyDataWritten(data);
        });

        test('throws StateError when device is disconnected', () async {
          await fixture
              .setDeviceConnectionState(BLEConnectionState.disconnected);

          expect(
            () => endpoint.add(data),
            throwsStateError,
          );
        });
      });

      group('addError', () {
        final error = Exception('error');
        test('emits added Error', () {
          expect(
            endpoint,
            emitsError(error),
          );

          endpoint.addError(error);
        });

        test('closes Stream', () {
          expect(
            endpoint,
            emitsInOrder([
              emitsError(error),
              emitsDone,
            ]),
          );

          endpoint.addError(error);
        });
      });

      group('AddStream()', () {
        test('adds Stream', () async {
          final data1 = [1, 2, 3];
          final data2 = [4, 5, 6];

          final stream = Stream.fromIterable([data1, data2]);

          await endpoint.addStream(stream);

          await fixture.verifyMultipleDataWrites([data1, data2]);
        });
      });

      group('done', () {
        test('resolves when close() is called', () async {
          expect(
            endpoint.done,
            completes,
          );

          await endpoint.close();
        });
      });
    });
  });
}
