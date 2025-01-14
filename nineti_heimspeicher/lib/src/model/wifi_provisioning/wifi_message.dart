part of 'wifi_provisioning.dart';

sealed class WiFiMessage extends Equatable {
  const WiFiMessage();
}

extension WiFiMessageToProto on WiFiMessage {
  to_pb.WiFiMessage toProto() {
    switch (this) {
      case WiFiConnectParameter():
        return to_pb.WiFiMessage(
          connect: (this as WiFiConnectParameter).toProto(),
        );
      case DisconnectWiFi():
        return to_pb.WiFiMessage(
          disconnect: (this as DisconnectWiFi).toProto(),
        );
      case ScanForWiFi():
        return to_pb.WiFiMessage(
          scan: (this as ScanForWiFi).toProto(),
        );
      case GetWiFiStatus():
        return to_pb.WiFiMessage(
          wifiStatus: (this as GetWiFiStatus).toProto(),
        );
    }
  }
}

class WiFiConnectParameter extends WiFiMessage {
  final String ssid;
  final String? password;

  WiFiConnectParameter({
    required this.ssid,
    this.password,
  });

  @override
  List<Object?> get props => [
        ssid,
        password,
      ];
}

extension ConnectToProto on WiFiConnectParameter {
  to_pb.Connect toProto() {
    return to_pb.Connect(
      connectArgs: ConnectArgs(
        ssid: ssid,
        password: password,
      ),
    );
  }
}

class DisconnectWiFi extends WiFiMessage {
  @override
  List<Object?> get props => [];
}

extension DisconnectToProto on DisconnectWiFi {
  to_pb.Disconnect toProto() {
    return to_pb.Disconnect();
  }
}

class ScanForWiFi extends WiFiMessage {
  @override
  List<Object?> get props => [];
}

extension ScanToProto on ScanForWiFi {
  to_pb.Scan toProto() {
    return to_pb.Scan();
  }
}

class GetWiFiStatus extends WiFiMessage {
  @override
  List<Object?> get props => [];
}

extension GetWiFiStatusToProto on GetWiFiStatus {
  to_pb.GetWiFiStatus toProto() {
    return to_pb.GetWiFiStatus();
  }
}
