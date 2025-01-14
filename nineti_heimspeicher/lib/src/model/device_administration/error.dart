part of 'device_administration.dart';

class DeviceAdministrationError extends DeviceAdministrationUpdate {
  final String message;

  DeviceAdministrationError({
    required this.message,
  });

  @override
  List<Object?> get props => [
        message,
      ];
}

extension LastErrorToModel on from_pb.LastError {
  DeviceAdministrationError toModel() {
    return DeviceAdministrationError(
      message: message,
    );
  }
}
