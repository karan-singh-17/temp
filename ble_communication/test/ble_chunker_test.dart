import 'dart:async';
import 'dart:typed_data';

import 'package:ble_communication/ble_communication.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

class MockDuplexCommunication extends Mock implements DuplexCommunication {}

void main() {
  group('BLEChunker', () {
    final chunkSize = 3;

    late PublishSubject<Uint8List> receiveStream;
    late MockDuplexCommunication lowerLayer;
    bool receiveStreamCanceled = false;

    late BLEChunker sut;

    setUp(() {
      receiveStreamCanceled = false;
      receiveStream = PublishSubject(
        onCancel: () => receiveStreamCanceled = true,
      );
      lowerLayer = MockDuplexCommunication();

      sut = BLEChunker(
        lowerLayer: lowerLayer,
        chunkSize: chunkSize,
      );
    });

    test('can be instanciated', () {
      expect(
        sut,
        isA<BLEChunker>(),
      );
    });

    group('as Stream', () {
      final data = [
        [1, 2, 3],
        [4, 5, 6],
      ];

      setUp(() {
        when(
          () => lowerLayer.listen(any(),
              onDone: any(named: 'onDone'),
              onError: any(named: 'onError'),
              cancelOnError: any(named: 'cancelOnError')),
        ).thenAnswer((invocation) {
          return receiveStream.listen(invocation.positionalArguments[0],
              onDone: invocation.namedArguments[#onDone],
              onError: invocation.namedArguments[#onError],
              cancelOnError: invocation.namedArguments[#cancelOnError]);
        });
      });

      void publishStreamOnReceiveStream(Stream<List<int>> stream) {
        receiveStream.addStream(stream.map(Uint8List.fromList));
      }

      test('emits received Data from lowerLayer', () {
        expect(
          sut,
          emitsInOrder(data.map(Uint8List.fromList)),
        );

        publishStreamOnReceiveStream(Stream.fromIterable(data));
      });

      test('canceling the stream cancels the lower layer stream aswell',
          () async {
        final subscription = sut.listen((_) {});

        await subscription.cancel();

        expect(
          receiveStreamCanceled,
          isTrue,
        );
      });
    });

    group('Add()', () {
      final smallMessage = [1, 2, 3];
      final largeMessage = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

      setUp(() {
        when(() => lowerLayer.add(any())).thenAnswer((_) => Future.value());
      });

      Future<void> verifyMessageAdded(List<int> message) async {
        await Future.delayed(Duration.zero);
        verify(() => lowerLayer.add(message));
      }

      test('adds data smaller thant the MTU to the lowerLayer', () async {
        sut.add(smallMessage);

        await verifyMessageAdded(smallMessage);
      });

      test('splits larger messages into chunks and adds them to the lowerLayer',
          () async {
        final expectedChunks = [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
          [10, 11, 12],
          [13],
        ];

        sut.add(largeMessage);

        await Future.wait(expectedChunks.map(verifyMessageAdded));
      });

      test('adds an empty event to the lower layer', () async {
        sut.add([]);

        await verifyMessageAdded([]);
      });
    });

    group('AddStream()', () {
      final mixedData = [
        [1],
        [2, 3],
        [4, 5, 6, 7],
        [8, 9, 10, 11, 12, 13],
        [14, 15, 16],
      ];

      List<List<int>> addedStreamsAsLists = [];

      setUp(() {
        registerFallbackValue(Stream<List<int>>.empty());
        when(() => lowerLayer.addStream(any())).thenAnswer((invocation) async {
          final stream =
              (invocation.positionalArguments[0] as Stream<List<int>>);

          final list = await stream.toList();
          addedStreamsAsLists = list;
          return Future.value();
        });
      });

      test('adds chunked messages to the lowerLayer', () async {
        await sut.addStream(Stream.fromIterable(mixedData));

        expect(addedStreamsAsLists, [
          [1],
          [2, 3],
          [4, 5, 6],
          [7],
          [8, 9, 10],
          [11, 12, 13],
          [14, 15, 16],
        ]);
      });

      group('addError', () {
        final error = Exception('error');

        void verifyErrorAdded(Object error) {
          verify(() => lowerLayer.addError(error, any()));
        }

        test('adds the error to the lower layer', () {
          sut.addError(error);

          verifyErrorAdded(error);
        });
      });

      group('done', () {
        setUp(() {
          when(() => lowerLayer.done).thenAnswer((_) => Future.value());
        });

        void verifyDoneCalled() {
          verify(() => lowerLayer.done);
        }

        test('is done when lowerLayer is done', () async {
          await sut.done;

          verifyDoneCalled();
        });
      });

      group('close()', () {
        setUp(() {
          when(() => lowerLayer.close()).thenAnswer((_) => Future.value());
        });

        void verifyCloseCalledOnLowerLayer() {
          verify(() => lowerLayer.close());
        }

        test('closes the lower layer', () async {
          await sut.close();

          verifyCloseCalledOnLowerLayer();
        });
      });
    });
  });
}
