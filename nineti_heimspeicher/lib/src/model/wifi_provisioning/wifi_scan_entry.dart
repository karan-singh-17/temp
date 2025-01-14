part of 'wifi_provisioning.dart';

class WiFiScanEntry extends Equatable {
  final String ssid;
  final int signalStrength;
  final List<int> bssid;
  final bool needsPassword;

  WiFiScanEntry({
    required this.ssid,
    required this.signalStrength,
    required this.bssid,
    required this.needsPassword,
  });

  @override
  List<Object?> get props => [
        ssid,
        signalStrength,
        bssid,
        needsPassword,
      ];
}

extension WiFiScanEntryToModel on from_pb.WiFiScanEntry {
  WiFiScanEntry toModel() {
    return WiFiScanEntry(
      ssid: ssid,
      signalStrength: signalStrength,
      bssid: bssid,
      needsPassword: needsPassword,
    );
  }
}
