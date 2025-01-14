import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_cloud.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_device_administration.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_wifi.dart';
import 'package:nineti_heimspeicher/src/model/cloud_provisioning/cloud_provisioning.dart';
import 'package:rxdart/rxdart.dart';

class MockHeimspeicherSystemWifi extends Mock
    implements HeimspeichersystemWiFi {}

class MockHeimspeicherSystemDeviceAdministration extends Mock
    implements HeimspeichersystemDeviceAdministration {}

class MockHeimspeicherSystemCloud extends Mock
    implements HeimspeichersystemCloud {}

void main() {
  group('HeimspeicherSystem', () {
    late MockHeimspeicherSystemCloud cloud;
    late MockHeimspeicherSystemDeviceAdministration deviceAdministration;
    late MockHeimspeicherSystemWifi wifi;

    late HeimspeicherSystem sut;

    setUp(() {
      cloud = MockHeimspeicherSystemCloud();
      deviceAdministration = MockHeimspeicherSystemDeviceAdministration();
      wifi = MockHeimspeicherSystemWifi();

      sut = HeimspeicherSystem.withDependencies(
        cloud: cloud,
        deviceAdministration: deviceAdministration,
        wifi: wifi,
      );
    });
    test('can be instanciated', () {
      expect(
        sut,
        isA<HeimspeicherSystem>(),
      );
    });

    group('close', () {
      void verifyWifiClosed() {
        verify(() => wifi.close());
      }

      void verifyDeviceAdministrationClosed() {
        verify(() => deviceAdministration.close());
      }

      void verifyCloudClosed() {
        verify(() => cloud.close());
      }

      setUp(() {
        when(() => wifi.close()).thenAnswer((_) async {});
        when(() => deviceAdministration.close()).thenAnswer((_) async {});
        when(() => cloud.close()).thenAnswer((_) async {});
      });

      test('closes  wifi', () async {
        await sut.close();
        verifyWifiClosed();
      });

      test('closes  deviceAdministration', () async {
        await sut.close();
        verifyDeviceAdministrationClosed();
      });

      test('closes cloud', () async {
        await sut.close();
        verifyCloudClosed();
      });
    });

    group('WiFi', () {
      final wifiConnectParameter = WiFiConnectParameter(
        ssid: 'ssid',
        password: 'password',
      );

      void verifyDisconnectCalled() {
        verify(() => wifi.disconnect());
      }

      void verifyWifiScanCalled() {
        verify(() => wifi.scan());
      }

      void verifyWiFiConnectCalledWithParameter(
          WiFiConnectParameter parameter) {
        verify(() => wifi.connect(parameter));
      }

      setUp(() {
        when(() => wifi.status).thenAnswer((_) =>
            Stream<WiFiStatus>.value(WiFiStatus.connecting)
                .shareValueSeeded(WiFiStatus.unknown));
        when(() => wifi.disconnect()).thenAnswer((_) async {});
        when(() => wifi.scan()).thenAnswer((_) async => []);
        registerFallbackValue(wifiConnectParameter);
        when(() => wifi.connect(any())).thenAnswer((_) async {});
      });

      test('wifiStatusStream emits the values of wifi.status stream', () {
        expect(
            sut.wifiStatusStream,
            emitsInOrder(
              [
                WiFiStatus.unknown,
                WiFiStatus.connecting,
              ],
            ));
      });

      test('disconnectWiFi disconnects the wifi', () async {
        await sut.disconnectWiFi();
        verifyDisconnectCalled();
      });

      test('scanForWifi calls wifi.scan', () async {
        await sut.scanForWifi();
        verifyWifiScanCalled();
      });

      test('connectToWifi calls wifi.connect with the given parameter', () {
        sut.connectToWifi(wifiConnectParameter);
        verifyWiFiConnectCalledWithParameter(wifiConnectParameter);
      });
    });
    group('DeviceAdministration', () {
      final uri = 'URI';
      final slotInfo = [
        FirmwareSlotInformation(
          hash: '',
          version: '1',
          status: SlotStatus.active,
        ),
      ];

      void verifyCreateFirmwareUpgradeCalledWithUri(String uri) {
        verify(() => deviceAdministration.createFirmwareUgrade(uri));
      }

      void verifyRebootDeviceCalled() =>
          verify(() => deviceAdministration.rebootDevice());

      setUp(() {
        when(() => deviceAdministration.createFirmwareUgrade(uri)).thenAnswer(
          (invocation) => FirmwareUpgrade(
            receiveStream: Stream.empty(),
            send: (_) {},
            uri: invocation.positionalArguments.first,
            deviceState: ValueConnectableStream.seeded(
              Stream.empty(),
              DeviceState.unknown,
            ),
          ),
        );

        when(() => deviceAdministration.deviceState).thenAnswer((_) =>
            Stream.value(DeviceState.installing)
                .shareValueSeeded(DeviceState.idle));

        when(() => deviceAdministration.getSlotStates()).thenAnswer(
          (_) async => slotInfo,
        );
      });

      test(
          'createFirmwareUpgrade passes the uri to deviceAdministration.createFirmwareUpgrade',
          () {
        sut.createFirmwareUpgrade(uri);
        verifyCreateFirmwareUpgradeCalledWithUri(uri);
      });

      test('deviceState emits values from deviceAdministration.deviceState',
          () {
        expect(
          sut.deviceState,
          emitsInOrder([
            DeviceState.idle,
            DeviceState.installing,
          ]),
        );
      });

      test(
          'getFirmwareSlotInformation returns firmware Information from deviceAdministration.getSlotStates',
          () async {
        expect(
          await sut.getFirmwareSlotInformation(),
          slotInfo,
        );
      });

      test('rebootDevice calls deviceAdministration.rebootDevice', () async {
        await sut.rebootDevice();
        verifyRebootDeviceCalled();
      });
    });

    group('Cloud', () {
      final provisioningData = Uint8List.fromList([1, 2, 3]);

      void verifyProvisioningRequestCalledWithData(Uint8List provisioningData) {
        verify(() => cloud.provisiongDevice(provisioningData));
      }

      setUp(() {
        when(() => cloud.status).thenAnswer((_) =>
            Stream.value(CloudProvisioningStatus.provisioning)
                .shareValueSeeded(CloudProvisioningStatus.unknown));
      });

      test('cloudProvisioninsStatus stream emits values from cloud.status', () {
        expect(
            sut.cloudProvisioningStatus,
            emitsInOrder([
              CloudProvisioningStatus.unknown,
              CloudProvisioningStatus.provisioning,
            ]));
      });

      test(
          'provisionCloudConnection calls cloud.provisionDevice with given provisioningData',
          () async {
        await sut.provisionCloudConnection(provisioningData);
        verifyProvisioningRequestCalledWithData(provisioningData);
      });
    });
  });
}
