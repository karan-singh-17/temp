part of 'cloud_provisioning.dart';

sealed class CloudProvisioningUpdate extends Equatable {
  const CloudProvisioningUpdate();
}

extension CloudProvisioningUpdateToModel on from_pb.CloudProvisioningUpdate {
  CloudProvisioningUpdate toModel() {
    switch (whichUpdate()) {
      case from_pb.CloudProvisioningUpdate_Update.provisioningStatus:
        return provisioningStatus.toModel();
      case from_pb.CloudProvisioningUpdate_Update.notSet:
        // Fallthrough
        break;
    }

    throw Exception("Can not convert WiFiUpdate to model: $this");
  }
}

extension CloudProvisioningUpdateFromBuffer on CloudProvisioningUpdate {
  static CloudProvisioningUpdate fromBuffer(List<int> buffer) {
    return from_pb.CloudProvisioningUpdate.fromBuffer(buffer).toModel();
  }
}
