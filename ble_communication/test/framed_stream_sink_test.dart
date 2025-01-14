import 'dart:async';

import 'package:ble_communication/src/framed_stream_sink.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockStreamSink extends Mock implements StreamSink<List<int>> {}

void main() {
  group('FramedStreamSink', () {
    late FramedStreamSink framedStreamSink;
    late MockStreamSink mockStreamSink;

    setUp(() {
      mockStreamSink = MockStreamSink();
      framedStreamSink = FramedStreamSink(mockStreamSink);
    });

    void verifyDataAdded(List<int> data) {
      verify(() => mockStreamSink.add(data));
    }

    test('can be instanciated', () {
      expect(
        framedStreamSink,
        isA<FramedStreamSink>(),
      );
    });

    group('add()', () {
      final writeData = [1, 2, 3];

      test('packages the data, prefixing the lenght als 4 byte LE', () {
        framedStreamSink.add(writeData);
        verifyDataAdded([3, 0, 0, 0, ...writeData]);
      });

      test('packages empty data, prefixing the length as 4 byte LE', () {
        framedStreamSink.add([]);
        verifyDataAdded([0, 0, 0, 0]);
      });
    });

    group('addError()', () {
      setUp(() {
        when(() => mockStreamSink.addError(any()))
            .thenAnswer((invocation) async {});
      });

      void verifyErrorAdded(Object error) {
        verify(() => mockStreamSink.addError(error));
      }

      test('emits the Error', () {
        final error = Exception('error');
        framedStreamSink.addError(error);

        verifyErrorAdded(error);
      });
    });

    group('addStream()', () {
      void verifyMultipleDataAdded(List<List<int>> dataList) {
        for (final data in dataList) {
          verifyDataAdded(data);
        }
      }

      test('adds Stream', () async {
        final data1 = [1];
        final data2 = [2, 2];

        final stream = Stream.fromIterable([data1, data2]);

        await framedStreamSink.addStream(stream);

        verifyMultipleDataAdded([
          [1, 0, 0, 0, ...data1],
          [2, 0, 0, 0, ...data2]
        ]);
      });
    });

    group('close()', () {
      setUp(() {
        when(() => mockStreamSink.close()).thenAnswer((invocation) async {});
      });

      void verifyCloseCalled() {
        verify(() => mockStreamSink.close());
      }

      test('resolves when close() is alled', () async {
        await framedStreamSink.close();

        verifyCloseCalled();
      });
    });

    group('done', () {
      setUp(() {
        when(() => mockStreamSink.done).thenAnswer((invocation) async {});
        when(() => mockStreamSink.close()).thenAnswer((invocation) async {});
      });

      void verifyDoneCalled() {
        verify(() => mockStreamSink.done);
      }

      test('resolves when close() is alled', () async {
        await framedStreamSink.close();
        await framedStreamSink.done;

        verifyDoneCalled();
      });
    });
  });
}
