part of 'wifi_provisioning.dart';

class WifiScanResults extends WiFiUpdate {
  final List<WiFiScanEntry> entries;

  WifiScanResults({
    required this.entries,
  });

  @override
  List<Object?> get props => [
        entries,
      ];
}

extension WifiScanResultsToModel on from_pb.WiFiScanResults {
  WifiScanResults toModel() {
    return WifiScanResults(
      entries: wifiScanEntries.map((e) => e.toModel()).toList(),
    );
  }
}
