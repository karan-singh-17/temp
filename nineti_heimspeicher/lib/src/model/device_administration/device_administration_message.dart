part of 'device_administration.dart';

sealed class DeviceAdministrationMessage extends Equatable {
  const DeviceAdministrationMessage();
}

extension DeviceAdministrationMessageToProto on DeviceAdministrationMessage {
  to_pb.DeviceAdministrationMessage toProto() {
    switch (this) {
      case GetSlotStates():
        return to_pb.DeviceAdministrationMessage(
          getSlotStates: (this as GetSlotStates).toProto(),
        );
      case GetDeviceState():
        return to_pb.DeviceAdministrationMessage(
          getDeviceState: (this as GetDeviceState).toProto(),
        );
      case GetBundleInformation():
        return to_pb.DeviceAdministrationMessage(
          getBundleInformation: (this as GetBundleInformation).toProto(),
        );
      case InstallBundle():
        return to_pb.DeviceAdministrationMessage(
          installBundle: (this as InstallBundle).toProto(),
        );
      case RebootDevice():
        return to_pb.DeviceAdministrationMessage(
          rebootDevice: (this as RebootDevice).toProto(),
        );
    }
  }
}

class GetSlotStates extends DeviceAdministrationMessage {
  @override
  List<Object?> get props => [];
}

extension GetSlotStatesToProto on GetSlotStates {
  to_pb.GetSlotStates toProto() {
    return to_pb.GetSlotStates();
  }
}

class GetDeviceState extends DeviceAdministrationMessage {
  @override
  List<Object?> get props => [];
}

extension GetDeviceStateToProto on GetDeviceState {
  to_pb.GetDeviceState toProto() {
    return to_pb.GetDeviceState();
  }
}

class GetBundleInformation extends DeviceAdministrationMessage {
  final String uri;

  GetBundleInformation({required this.uri});

  @override
  List<Object?> get props => [uri];
}

extension GetBundleInformationToProto on GetBundleInformation {
  to_pb.GetBundleInformation toProto() {
    return to_pb.GetBundleInformation(uri: uri);
  }
}

class InstallBundle extends DeviceAdministrationMessage {
  final String uri;

  InstallBundle({required this.uri});

  @override
  List<Object?> get props => [uri];
}

extension InstallBundleToProto on InstallBundle {
  to_pb.InstallBundle toProto() {
    return to_pb.InstallBundle(uri: uri);
  }
}

class RebootDevice extends DeviceAdministrationMessage {
  @override
  List<Object?> get props => [];
}

extension RebootDeviceToProto on RebootDevice {
  to_pb.RebootDevice toProto() {
    return to_pb.RebootDevice();
  }
}
