part of 'cloud_provisioning.dart';

class CloudProvisioningStatus extends CloudProvisioningUpdate {
  static const unknown = CloudProvisioningStatus._('unknown');
  static const unprovisioned = CloudProvisioningStatus._('unprovisioned');
  static const provisioned = CloudProvisioningStatus._('provisioned');
  static const provisioning = CloudProvisioningStatus._('provisioning');
  static const provisioningFailed =
      CloudProvisioningStatus._('provisioningFailed');

  final String value;

  const CloudProvisioningStatus._(this.value);

  @override
  String toString() {
    return 'CloudProvisioningStatus($value)';
  }

  @override
  List<Object?> get props => [
        value,
      ];
}

extension CloudProvisioningStatusUpdateToModel on from_pb.ProvisioningStatus {
  CloudProvisioningStatus toModel() {
    switch (this) {
      case from_pb.ProvisioningStatus.PROVISIONING_STATUS_UNKNOWN:
        return CloudProvisioningStatus.unknown;
      case from_pb.ProvisioningStatus.PROVISIONING_STATUS_UNPROVISIONED:
        return CloudProvisioningStatus.unprovisioned;
      case from_pb.ProvisioningStatus.PROVISIONING_STATUS_PROVISIONED:
        return CloudProvisioningStatus.provisioned;
      case from_pb.ProvisioningStatus.PROVISIONING_STATUS_PROVISIONING:
        return CloudProvisioningStatus.provisioning;
      case from_pb.ProvisioningStatus.PROVISIONING_STATUS_PROVISIONING_FAILED:
        return CloudProvisioningStatus.provisioningFailed;
    }
    throw Exception("Can not convert CloudProvisioningStatus to model: $this");
  }
}
