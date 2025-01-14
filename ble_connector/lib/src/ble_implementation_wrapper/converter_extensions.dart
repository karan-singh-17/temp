import 'package:ble_connector/ble_connector.dart';
import 'package:ble_connector/src/model/ble_device_endpoint.dart';
import 'package:ble_connector/src/model/ble_status.dart';
import 'package:ble_connector/src/model/device_connection_update.dart';
import 'package:ble_connector/src/model/model.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as frb;

extension ToDeviceConnectionUpdate on frb.ConnectionStateUpdate {
  DeviceConnectionUpdate toDeviceConnectionUpdate() {
    return DeviceConnectionUpdate(
      deviceId: deviceId,
      connectionState: connectionState.toConnectionState(),
    );
  }
}

extension ToConnectionState on frb.DeviceConnectionState {
  BLEConnectionState toConnectionState() {
    switch (this) {
      case frb.DeviceConnectionState.connecting:
        return BLEConnectionState.connecting;
      case frb.DeviceConnectionState.connected:
        return BLEConnectionState.connected;
      case frb.DeviceConnectionState.disconnecting:
        return BLEConnectionState.disconnecting;
      case frb.DeviceConnectionState.disconnected:
        return BLEConnectionState.disconnected;
    }
  }
}

extension ToBleStatus on frb.BleStatus {
  BLEStatus toBleStatus() {
    switch (this) {
      case frb.BleStatus.unknown:
        return BLEStatus.unknown;
      case frb.BleStatus.unsupported:
        return BLEStatus.unsupported;
      case frb.BleStatus.unauthorized:
        return BLEStatus.unauthorized;
      case frb.BleStatus.poweredOff:
        return BLEStatus.poweredOff;
      case frb.BleStatus.locationServicesDisabled:
        return BLEStatus.locationServicesDisabled;
      case frb.BleStatus.ready:
        return BLEStatus.ready;
    }
  }
}

extension ToBleDeviceAdvertinfo on frb.DiscoveredDevice {
  BLEDeviceAdvertInfo toBleDeviceAdvertInfo() => BLEDeviceAdvertInfo(
        name: name,
        id: id,
        manufacturerData: manufacturerData,
      );
}

extension ToFrbUuid on String {
  frb.Uuid toFrbUuid() {
    return frb.Uuid.parse(this);
  }
}

extension ToQualifiedCharacteristic on BLEDeviceEndpoint {
  frb.QualifiedCharacteristic toQualifiedCharacteristic() =>
      frb.QualifiedCharacteristic(
        characteristicId: frb.Uuid.parse(characteristicUuid),
        serviceId: frb.Uuid.parse(serviceUuid),
        deviceId: deviceId,
      );
}

extension ToService on frb.Service {
  Service toService() {
    return Service(
      uuid: '$id',
      characteristics:
          characteristics.map((c) => c.toCharacteristic()).toList(),
    );
  }
}

extension ToCharacteristic on frb.Characteristic {
  Characteristic toCharacteristic() {
    return Characteristic(
      uuid: '$id',
      isReadable: isReadable,
      isWritableWithoutResponse: isWritableWithoutResponse,
      isWritableWithResponse: isWritableWithResponse,
      isNotifiable: isNotifiable,
      isIndicatable: isIndicatable,
    );
  }
}
