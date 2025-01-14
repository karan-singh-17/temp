// ignore_for_file: prefer_const_constructors

import 'package:ble_connector/ble_connector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final endpoint = BLEEndpoint(
    characteristicUuid: 'characteristicUuid',
    serviceUuid: 'serviceUuid',
  );
  group('BleEndpoint', () {
    test('can be instanciated', () {
      expect(
        BLEEndpoint(
          characteristicUuid: 'characteristicUuid',
          serviceUuid: 'serviceUuid',
        ),
        isNotNull,
      );
    });
    group('equality:', () {
      test(
          'endpoints are equal '
          'when service and characteristic UUID matches', () {
        expect(
          BLEEndpoint(
            characteristicUuid: endpoint.characteristicUuid,
            serviceUuid: endpoint.serviceUuid,
          ),
          endpoint,
        );
      });

      test(
          'endpoints are not equal '
          'when service UUID is equal and characteristic differs', () {
        expect(
          BLEEndpoint(
            characteristicUuid: '',
            serviceUuid: endpoint.serviceUuid,
          ),
          isNot(equals(endpoint)),
        );
      });

      test(
          'endpoints are not equal '
          'when characteristic UUID is equal and service differs', () {
        expect(
          BLEEndpoint(
            characteristicUuid: endpoint.characteristicUuid,
            serviceUuid: '',
          ),
          isNot(equals(endpoint)),
        );
      });
    });
  });
}
