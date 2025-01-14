import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:nineti_heimspeicher/src/model/cloud_provisioning/cloud_provisioning.dart';
import 'package:nineti_heimspeicher/src/model/model.dart';

List<int> serializeDeviceAdministreationMessage(
    DeviceAdministrationMessage message) {
  return message.toProto().writeToBuffer();
}

DeviceAdministrationUpdate deserializeDeviceAdministreationUpdate(
    List<int> buffer) {
  return DeviceAdministrationUpdateFromBuffer.fromBuffer(buffer);
}

List<int> serializeWiFiMessage(WiFiMessage message) {
  return message.toProto().writeToBuffer();
}

WiFiUpdate deserializeWiFiUpdate(List<int> buffer) {
  return WiFiUpdateFromBuffer.fromBuffer(buffer);
}

List<int> serializeCloudProvisioningMessage(CloudProvisioningMessage message) {
  return message.toProto().writeToBuffer();
}

CloudProvisioningUpdate deserializeCloudProvisioningUpdate(List<int> buffer) {
  return CloudProvisioningUpdateFromBuffer.fromBuffer(buffer);
}
