import 'dart:async';
import 'dart:typed_data';

import 'package:ble_communication/src/de_frame_transformer.dart';
import 'package:test/test.dart';

void main() {
  group('DeFrameTransformer', () {
    late DeFrameTransformer deFrameTransformer;
    late StreamController<Uint8List> dataSource;

    setUp(() {
      dataSource = StreamController();
      deFrameTransformer = DeFrameTransformer();
    });

    void dataSourceAdd(List<int> data) {
      dataSource.add(Uint8List.fromList(data));
    }

    test('can be instanciated', () {
      expect(
        deFrameTransformer,
        isA<DeFrameTransformer>(),
      );
    });

    group('bind()', () {
      test('emits a small package', () {
        final length = [3, 0, 0, 0];
        final data = [1, 2, 3];

        expect(
          deFrameTransformer.bind(dataSource.stream),
          emits(data),
        );

        dataSourceAdd([...length, ...data]);
      });

      test('emits an empty package', () {
        final length = [0, 0, 0, 0];
        final data = [];

        expect(
          deFrameTransformer.bind(dataSource.stream),
          emits(data),
        );

        dataSourceAdd([...length, ...data]);
      });

      test('emits a package build from two incoming messages', () {
        final length = [6, 0, 0, 0];
        final data1 = [1, 2, 3];
        final data2 = [4, 5, 6];

        expect(
          deFrameTransformer.bind(dataSource.stream),
          emits([...data1, ...data2]),
        );

        dataSourceAdd([...length, ...data1]);
        dataSourceAdd(data2);
      });

      test('emits a pacakge that starts in the middle of a message', () {
        final length1 = [1, 0, 0, 0];
        final data1 = [1];
        final length2 = [2, 0, 0, 0];
        final data2 = [2, 3];

        expect(
          deFrameTransformer.bind(dataSource.stream).skip(1),
          emits(data2),
        );

        dataSourceAdd([...length1, ...data1, ...length2]);
        dataSourceAdd(data2);
      });

      test('emits packages contained in one message', () {
        final length1 = [1, 0, 0, 0];
        final data1 = [1];
        final length2 = [2, 0, 0, 0];
        final data2 = [2, 3];

        expect(
          deFrameTransformer.bind(dataSource.stream),
          emitsInOrder([data1, data2]),
        );

        dataSourceAdd([
          ...length1,
          ...data1,
          ...length2,
          ...data2,
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
          deFrameTransformer.bind(dataSource.stream).skip(1),
          emits([...data2Part1, ...data2Part2]),
        );

        dataSourceAdd([
          ...length1,
          ...data1,
          ...length2Part1,
        ]);

        dataSourceAdd([
          ...length2Part2,
          ...data2Part1,
        ]);

        dataSourceAdd(data2Part2);
      });
    });
  });
}
