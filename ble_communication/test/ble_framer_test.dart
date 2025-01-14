import 'dart:async';
import 'dart:typed_data';

import 'package:ble_communication/ble_communication.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

class MockDuplexCommunication extends Mock implements DuplexCommunication {}

class TestFixture {
  late final BLEFramer communicator;
  late final MockDuplexCommunication _layer;
  late final PublishSubject<Uint8List> _notifyReceiveStream;

  TestFixture()
      : _layer = MockDuplexCommunication(),
        _notifyReceiveStream = PublishSubject() {
    setUpLowerLayer();
    communicator = BLEFramer(
      lowerLayer: _layer,
    );
  }

  void setUpLowerLayer() {
    when(() => _layer.add(any())).thenAnswer((_) => Future.value());
    when(() => _layer.listen(any())).thenAnswer((invocation) =>
        _notifyReceiveStream.listen(invocation.positionalArguments[0]));
    when(() => _layer.close()).thenAnswer((_) => Future.value());
    // when(() => _layer.addError(any(), any())).thenAnswer((_) {});
  }

  Future<void> verifyDataWritten(List<int> data) async {
    await runMicrotasks();

    verify(
      () => _layer.add(data),
    );
  }

  Future<void> verifyMultipleDataWrites(List<List<int>> data) async {
    await Future.wait(data.map((d) => verifyDataWritten(d)));
  }

  void publishToNotifyStream(List<int> data) {
    _notifyReceiveStream.add(Uint8List.fromList(data));
  }

  void publishManyToNotifyStream(List<List<int>> data) {
    for (final d in data) {
      _notifyReceiveStream.add(Uint8List.fromList(d));
    }
  }

  Future<void> runMicrotasks() async {
    await Future.delayed(Duration.zero);
  }
}

void main() {
  group('BLEFramer', () {
    late BLEFramer framer;
    late TestFixture fixture;

    setUp(() {
      fixture = TestFixture();
      framer = fixture.communicator;
    });

    test('can be instanciated', () {
      expect(
        framer,
        isA<BLEFramer>(),
      );
    });

    group('receiveStream', () {
      test('emits a small package', () {
        final length = [3, 0, 0, 0];
        final data = [1, 2, 3];

        expect(
          framer,
          emits(data),
        );

        fixture.publishToNotifyStream([
          // Package Length
          ...length,
          // Package Data
          ...data
        ]);
      });

      test('emits an empty package', () {
        final length = [0, 0, 0, 0];
        final data = [];

        expect(
          framer,
          emits(data),
        );

        fixture.publishToNotifyStream([
          // Package Length
          ...length,
          // Package Data
          ...data
        ]);
      });

      test('emits a package build from two incoming messages', () {
        final length = [6, 0, 0, 0];
        final data1 = [1, 2, 3];
        final data2 = [4, 5, 6];

        expect(
          framer,
          emits([...data1, ...data2]),
        );

        fixture.publishManyToNotifyStream([
          [
            // Package Length
            ...length,
            // Package Data
            ...data1
          ],
          data2
        ]);
      });

      test('emits a pacakge that starts in the middle of a message', () {
        final length1 = [1, 0, 0, 0];
        final data1 = [1];
        final length2 = [2, 0, 0, 0];
        final data2 = [2, 3];

        expect(
          framer.skip(1),
          emits(data2),
        );
        fixture.publishManyToNotifyStream([
          [
            // Package Length
            ...length1,
            // Package Data
            ...data1,

            /// Package 2 Length
            ...length2,
          ],
          data2,
        ]);
      });

      test('emits packages contained in one message', () {
        final length1 = [1, 0, 0, 0];
        final data1 = [1];
        final length2 = [2, 0, 0, 0];
        final data2 = [2, 3];

        expect(
          framer,
          emitsInOrder([data1, data2]),
        );

        fixture.publishManyToNotifyStream([
          [
            // Package Length
            ...length1,
            // Package Data
            ...data1,

            ...length2,
            ...data2,
          ],
          data2
        ]);
      });

      test('emits packages contained in several messages', () {
        final length1 = [1, 0, 0, 0];
        final data1 = [1];
        final length2Part1 = [10, 0];
        final length2Part2 = [0, 0];
        final data2Part1 = [1, 2, 3];
        final data2Part2 = [4, 5, 6, 7, 8, 9, 0];

        expect(
          framer.skip(1),
          emits([...data2Part1, ...data2Part2]),
        );

        fixture.publishManyToNotifyStream([
          [
            ...length1,
            ...data1,
            ...length2Part1,
          ],
          [
            ...length2Part2,
            ...data2Part1,
          ],
          data2Part2
        ]);
      });
    });

    group('StreamSink', () {
      group('add()', () {
        final writeData = [1, 2, 3];
        test('packages the data, prefixing the lenght als 4 byte LE', () async {
          framer.add(writeData);
          await fixture.verifyDataWritten([3, 0, 0, 0, ...writeData]);
        });

        test('packages empty data, prefixing the length as 4 byte LE',
            () async {
          framer.add([]);
          await fixture.verifyDataWritten([0, 0, 0, 0]);
        });
      });

      group('addError()', () {
        test('emits the Error', () async {
          final error = Exception('error');
          framer.addError(error);

          await fixture.runMicrotasks();

          verify(() => fixture._layer.addError(error, any()));
        });
      });

      group('addStream()', () {
        test('adds Stream', () async {
          final data1 = [1];
          final data2 = [2, 2];

          final stream = Stream.fromIterable([data1, data2]);

          await framer.addStream(stream);

          await fixture.verifyMultipleDataWrites([
            [1, 0, 0, 0, ...data1],
            [2, 0, 0, 0, ...data2]
          ]);
        });
      });

      group('done', () {
        test('resolves when close() is alled', () async {
          expect(
            framer.done,
            completes,
          );

          await framer.close();
        });
      });
    });
  });
}
