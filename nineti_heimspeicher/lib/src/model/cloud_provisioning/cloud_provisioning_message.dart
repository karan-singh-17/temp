part of 'cloud_provisioning.dart';

sealed class CloudProvisioningMessage extends Equatable {
  const CloudProvisioningMessage();
}

extension CloudProvisioningMessageToProto on CloudProvisioningMessage {
  to_pb.CloudProvisioningMessage toProto() {
    switch (this) {
      case ProvisionDeviceWithCloudData():
        return to_pb.CloudProvisioningMessage(
          provisionDevice: (this as ProvisionDeviceWithCloudData).toProto(),
        );
    }
  }
}

class ProvisionDeviceWithCloudData extends CloudProvisioningMessage {
  final Uint8List provisionData;

  const ProvisionDeviceWithCloudData({
    required this.provisionData,
  });

  @override
  List<Object?> get props => [
        provisionData,
      ];
}

extension ProvisionDeviceWithCloudDataToProto on ProvisionDeviceWithCloudData {
  to_pb.ProvisionDevice toProto() {
    return to_pb.ProvisionDevice(provisioningData: provisionData);
  }
}
