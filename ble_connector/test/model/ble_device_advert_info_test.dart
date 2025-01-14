// ignore_for_file: prefer_const_constructors,
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:ble_connector/ble_connector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const manufacturerData = [1, 2, 3];
  const id = 'id';
  const name = 'name';

  const map = {
    'name': name,
    'id': id,
    'manufacturerData': manufacturerData,
  };

  const info = BLEDeviceAdvertInfo(
    name: name,
    id: id,
    manufacturerData: manufacturerData,
  );
  group('BleDeviceAdvertInfo', () {
    test('can be instanciated', () {
      expect(
        BLEDeviceAdvertInfo(name: 'name', id: 'id'),
        isNotNull,
      );
    });

    group('equality:', () {
      test(
          'Infos are equal '
          'when id, name and manufacturerData are equal', () {
        expect(
          BLEDeviceAdvertInfo(
            name: name,
            id: id,
            manufacturerData: manufacturerData,
          ),
          info,
        );
      });

      test(
          'Infos are not equal '
          'when id is not equal', () {
        expect(
          BLEDeviceAdvertInfo(
            name: name,
            id: '',
            manufacturerData: manufacturerData,
          ),
          isNot(equals(info)),
        );
      });

      test(
          'Infos are not equal '
          'when name is not equal', () {
        expect(
          BLEDeviceAdvertInfo(
            name: '',
            id: id,
            manufacturerData: manufacturerData,
          ),
          isNot(equals(info)),
        );
      });

      test(
          'Infos are not equal '
          'when manufacturerData is not equal', () {
        expect(
          BLEDeviceAdvertInfo(
            name: name,
            id: id,
            manufacturerData: <int>[],
          ),
          isNot(equals(info)),
        );
      });
    });

    group('Serialization:', () {
      test(
          'fromJson() creates a info with '
          'correct id, name and manufacturerData', () {
        expect(
          BLEDeviceAdvertInfo.fromJson(map),
          info,
        );
      });

      test(
          'toJson() creates a map with '
          'correct id, name and manufacturerData', () {
        expect(
          info.toJson(),
          map,
        );
      });
    });
  });
}
