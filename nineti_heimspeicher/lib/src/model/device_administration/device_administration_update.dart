part of 'device_administration.dart';

sealed class DeviceAdministrationUpdate extends Equatable {
  const DeviceAdministrationUpdate();
}

extension DeviceAdministrationUpdateToModel
    on from_pb.DeviceAdministrationUpdate {
  DeviceAdministrationUpdate toModel() {
    switch (whichUpdate()) {
      case from_pb.DeviceAdministrationUpdate_Update.progress:
        return progress.toModel();
      case from_pb.DeviceAdministrationUpdate_Update.deviceState:
        return deviceState.toModel();
      case from_pb.DeviceAdministrationUpdate_Update.slotStates:
        return slotStates.toModel();
      case from_pb.DeviceAdministrationUpdate_Update.bundleInformation:
        bundleInformation.toModel();
      case from_pb.DeviceAdministrationUpdate_Update.error:
        return error.toModel();
      case from_pb.DeviceAdministrationUpdate_Update.notSet:
        // fallthrough
        break;
    }

    throw Exception(
        "Can not convert DeviceAdministrationUpdate to model: $this");
  }
}

extension DeviceAdministrationUpdateFromBuffer on DeviceAdministrationUpdate {
  static DeviceAdministrationUpdate fromBuffer(List<int> buffer) {
    return from_pb.DeviceAdministrationUpdate.fromBuffer(buffer).toModel();
  }
}
