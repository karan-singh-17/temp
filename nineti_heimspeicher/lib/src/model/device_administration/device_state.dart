part of 'device_administration.dart';

// use en enum-like class so we can subclass the DeviceAdministrationUpdate
class DeviceState extends DeviceAdministrationUpdate {
  static const DeviceState idle = DeviceState._('idle');
  static const DeviceState installing = DeviceState._('installing');
  static const DeviceState unknown = DeviceState._('unknown');

  final String _value;

  const DeviceState._(this._value);

  factory DeviceState.fromString(String value) {
    switch (value) {
      case 'idle':
        return DeviceState.idle;
      case 'installing':
        return DeviceState.installing;
      case 'unknown':
        return DeviceState.unknown;
      default:
        throw Exception('Invalid device state: $value');
    }
  }

  @override
  String toString() => _value;

  @override
  List<Object?> get props => [
        _value,
      ];
}

extension DevicestateToModel on from_pb.DeviceState {
  DeviceState toModel() {
    switch (this) {
      case from_pb.DeviceState.IDLE:
        return DeviceState.idle;
      case from_pb.DeviceState.INSTALLING:
        return DeviceState.installing;
      default:
        throw Exception('Invalid device state: $this');
    }
  }
}
