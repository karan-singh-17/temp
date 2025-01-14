// ignore_for_file: prefer_const_constructors

import 'package:ble_connector/src/model/ble_device_endpoint.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final endpoint = BLEDeviceEndpoint(
    deviceId: 'deviceId',
    characteristicUuid: 'characteristicUuid',
    serviceUuid: 'serviceUuid',
  );
  group('BleDeviceEndpoint', () {
    test('can be instanciated', () {
      expect(
        BLEDeviceEndpoint(
          deviceId: 'deviceId',
          characteristicUuid: 'characteristicUuid',
          serviceUuid: 'serviceUuid',
        ),
        isNotNull,
      );
    });

    group('equality:', () {
      test(
          'endpoints are equal '
          'when deviceId, characteristic and service Uuid match', () {
        expect(
          BLEDeviceEndpoint(
            deviceId: endpoint.deviceId,
            characteristicUuid: endpoint.characteristicUuid,
            serviceUuid: endpoint.serviceUuid,
          ),
          endpoint,
        );
      });

      test(
          'endpoints are not equal '
          'when service UUID does not match', () {
        expect(
          BLEDeviceEndpoint(
            deviceId: endpoint.deviceId,
            characteristicUuid: endpoint.characteristicUuid,
            serviceUuid: '',
          ),
          isNot(equals(endpoint)),
        );
      });

      test(
          'endpoints are not equal '
          'when characteristic UUID does not match', () {
        expect(
          BLEDeviceEndpoint(
            deviceId: endpoint.deviceId,
            characteristicUuid: '',
            serviceUuid: endpoint.serviceUuid,
          ),
          isNot(equals(endpoint)),
        );
      });

      test(
          'endpoints are not equal '
          'when deviceId does not match', () {
        expect(
          BLEDeviceEndpoint(
            deviceId: '',
            characteristicUuid: endpoint.characteristicUuid,
            serviceUuid: endpoint.serviceUuid,
          ),
          isNot(equals(endpoint)),
        );
      });
    });
  });
}
