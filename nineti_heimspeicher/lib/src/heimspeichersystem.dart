import 'dart:typed_data';

import 'package:ble_communication/ble_communication.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:logger/logger.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_cloud.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_device_administration.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_wifi.dart';
import 'package:flutter/widgets.dart';
import 'package:nineti_heimspeicher/src/model/cloud_provisioning/cloud_provisioning.dart';
import 'package:nineti_heimspeicher/src/protobuf_serde.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

/// {@template heimspeicher_system}
/// A Nineti Heimspeicher system.
///
/// This class provides functionality to interact with the Heimspeicher system
/// via bluetooth
/// {@endtemplate}
class HeimspeicherSystem {
  final HeimspeichersystemWiFi _wifi;
  final HeimspeichersystemDeviceAdministration _deviceAdministration;
  final HeimspeichersystemCloud _cloud;

  /// Constructs a new [HeimspeicherSystem] instance.
  ///
  /// The [btDeviceWrapper] holds the [BLEDevice] to communicate with
  /// and the [endpoint] parameter is used to specify the Bluetooth endpoint to
  /// write to and receive indications.
  ///
  /// Upon connection with a Bluetooth device, the WiFi status is automatically
  /// requested once
  factory HeimspeicherSystem({
    required BLEDevice device,
    required BLEEndpoint wifiProvisioningEndpoint,
    required BLEEndpoint deviceAdministrationEndpoint,
    required BLEEndpoint cloudProvisioningEndpoint,
    required int chunkSize,
  }) {
    HeimspeichersystemWiFi wifi = _createWiFi(
      device,
      wifiProvisioningEndpoint,
      chunkSize,
    );

    HeimspeichersystemDeviceAdministration deviceAdministation =
        _createDeviceAdministration(
      device,
      deviceAdministrationEndpoint,
      chunkSize,
    );

    HeimspeichersystemCloud cloud =
        _createCloud(device, cloudProvisioningEndpoint, chunkSize);

    return HeimspeicherSystem.withDependencies(
      wifi: wifi,
      deviceAdministration: deviceAdministation,
      cloud: cloud,
    );
  }

  static HeimspeichersystemCloud _createCloud(
      BLEDevice device, BLEEndpoint cloudProvisioningEndpoint, int chunkSize) {
    final cloudEndpoint = BLERawDataStreamEndpoint(
        device: device, writeEndpoint: cloudProvisioningEndpoint);
    final cloudChunker = BLEChunker(
      lowerLayer: cloudEndpoint,
      chunkSize: chunkSize,
    );
    final cloudSink = FramedStreamSink(cloudChunker);

    final cloud = HeimspeichersystemCloud(
      receiveStream: cloudEndpoint
          .transform(DeFrameTransformer())
          .map(deserializeCloudProvisioningUpdate),
      send: (message) =>
          cloudSink.add(serializeCloudProvisioningMessage(message)),
    );

    return cloud;
  }

  static HeimspeichersystemDeviceAdministration _createDeviceAdministration(
    BLEDevice device,
    BLEEndpoint deviceAdministrationEndpoint,
    int chunkSize,
  ) {
    final deviceAndministrationEndpoint = BLERawDataStreamEndpoint(
        device: device, writeEndpoint: deviceAdministrationEndpoint);
    final deviceAdministrationChunker = BLEChunker(
      lowerLayer: deviceAndministrationEndpoint,
      chunkSize: chunkSize,
    );
    final deviceAdministrationSink =
        FramedStreamSink(deviceAdministrationChunker);

    final deviceAdministation = HeimspeichersystemDeviceAdministration(
      receiveStream: deviceAndministrationEndpoint
          .transform(DeFrameTransformer())
          .map(deserializeDeviceAdministreationUpdate),
      send: (message) => deviceAdministrationSink
          .add(serializeDeviceAdministreationMessage(message)),
    );
    return deviceAdministation;
  }

  static HeimspeichersystemWiFi _createWiFi(
      BLEDevice device, BLEEndpoint wifiProvisioningEndpoint, int chunkSize) {
    final wifiEndpoint = BLERawDataStreamEndpoint(
        device: device, writeEndpoint: wifiProvisioningEndpoint);
    final wiFiChunker = BLEChunker(
      lowerLayer: wifiEndpoint,
      chunkSize: chunkSize,
    );
    final wifiSink = FramedStreamSink(wifiEndpoint);

    final wifi = HeimspeichersystemWiFi(
      receiveStream: wiFiChunker
          .transform(DeFrameTransformer())
          .map(deserializeWiFiUpdate),
      send: (message) => wifiSink.add(serializeWiFiMessage(message)),
    );

    return wifi;
  }

  HeimspeicherSystem.withDependencies({
    required HeimspeichersystemWiFi wifi,
    required HeimspeichersystemDeviceAdministration deviceAdministration,
    required HeimspeichersystemCloud cloud,
  })  : _wifi = wifi,
        _deviceAdministration = deviceAdministration,
        _cloud = cloud;

  /// Returns the current WiFi status.
  ///
  /// Is "disconnected" when no bluetooth connection is established.
  ValueStream<WiFiStatus> get wifiStatusStream => _wifi.status;

  /// Requests the Heimspeichersystem to scan for WiFi networks and
  /// returns a list of WiFi networks found.
  ///
  /// The scan results are also published on teh [wifiScanResults] stream.
  ///
  /// Throws a [TimeoutException] if the scan takes too long.
  Future<List<WiFiScanEntry>> scanForWifi() => _wifi.scan();

  /// Requests the Heimspeichersystem to connect to the specified WiFi network.
  Future<void> connectToWifi(WiFiConnectParameter parameter) =>
      _wifi.connect(parameter);

  /// Disconnects the Heimspeichersystem from the WiFi network.
  Future<void> disconnectWiFi() async => _wifi.disconnect();

  /// Gracefully close the Heimspeicher system
  Future<void> close() async {
    await _wifi.close();
    await _deviceAdministration.close();
    await _cloud.close();
    Logger().i("closed");
  }

  /// Create a [FirmwareUpgrade] to upgrade the firmware of this device
  /// with the bundle pointed to by [uri].
  FirmwareUpgrade createFirmwareUpgrade(String uri) =>
      _deviceAdministration.createFirmwareUgrade(uri);

  /// Get the current state of the device.
  ValueStream<DeviceState> get deviceState => _deviceAdministration.deviceState;

  /// Get Information about the Firmware(s) installed on the device
  ///
  /// Throws a [TimeoutException] if the request takes too long.
  Future<List<FirmwareSlotInformation>> getFirmwareSlotInformation() =>
      _deviceAdministration.getSlotStates();

  /// Request a reboot of the device
  Future<void> rebootDevice() async => _deviceAdministration.rebootDevice();

  /// A Stream of the connection status to the cloud
  ValueStream<CloudProvisioningStatus> get cloudProvisioningStatus =>
      _cloud.status;

  /// Provision the device with the given provisioning data.
  Future<void> provisionCloudConnection(Uint8List provisioningData) async =>
      _cloud.provisiongDevice(provisioningData);
}

class HeimspeicherSystemProvider extends SingleChildStatelessWidget {
  HeimspeicherSystemProvider({
    required this.chunkSize,
    required this.device,
    this.child,
    super.key,
  });

  final BLEDevice device;
  final int chunkSize;
  final Widget? child;

  final wiFiProvisioningEndpoint = BLEEndpoint(
    serviceUuid: '0d05feb3-35e7-43d2-9e73-7bea219e412e',
    characteristicUuid: 'e00417e6-c782-4b83-ab67-1e20e211c612',
  );

  final deviceAdministrationEndpoint = BLEEndpoint(
    serviceUuid: 'a05238bc-4249-4b95-86b0-a90e30533857',
    characteristicUuid: '04b93536-6e2a-4a2c-8715-1de048a0d2d9',
  );

  final cloudEndpoint = BLEEndpoint(
    serviceUuid: 'a44f438e-2f83-4f19-b77e-1da0b7374c98',
    characteristicUuid: '2f7dea3d-406e-40b3-bdf3-36dd9ee99325',
  );

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Provider(
      create: (_) => HeimspeicherSystem(
        wifiProvisioningEndpoint: wiFiProvisioningEndpoint,
        deviceAdministrationEndpoint: deviceAdministrationEndpoint,
        cloudProvisioningEndpoint: cloudEndpoint,
        device: device,
        chunkSize: chunkSize,
      ),
      child: child,
    );
  }
}
