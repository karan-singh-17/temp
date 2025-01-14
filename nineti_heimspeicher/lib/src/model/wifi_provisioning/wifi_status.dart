part of 'wifi_provisioning.dart';

class WiFiStatus extends WiFiUpdate {
  static const disconnected = WiFiStatus._('Disconnected');
  static const scanning = WiFiStatus._('Scanning');
  static const connecting = WiFiStatus._('Connecting');
  static const connected = WiFiStatus._('Connected');
  static const unknown = WiFiStatus._('Unknown');

  final String _value;

  const WiFiStatus._(this._value);

  @override
  String toString() => _value;

  factory WiFiStatus.fromString(String value) {
    switch (value) {
      case 'Disconnected':
        return WiFiStatus.disconnected;
      case 'Scanning':
        return WiFiStatus.scanning;
      case 'Connecting':
        return WiFiStatus.connecting;
      case 'Connected':
        return WiFiStatus.connected;
      case 'Unknown':
        return WiFiStatus.unknown;
      default:
        throw Exception('Invalid WiFi status: $value');
    }
  }

  @override
  List<Object?> get props => [_value];
}

extension WiFiStatusToModel on from_pb.WiFiStatus {
  WiFiStatus toModel() {
    switch (this) {
      case from_pb.WiFiStatus.DISCONNECTED:
        return WiFiStatus.disconnected;
      case from_pb.WiFiStatus.SCANNING:
        return WiFiStatus.scanning;
      case from_pb.WiFiStatus.CONNECTING:
        return WiFiStatus.connecting;
      case from_pb.WiFiStatus.CONNECTED:
        return WiFiStatus.connected;
      case from_pb.WiFiStatus.UNKNOWN:
        return WiFiStatus.unknown;
    }

    throw Exception("Can not convert WiFiStatus to model: $this");
  }
}
