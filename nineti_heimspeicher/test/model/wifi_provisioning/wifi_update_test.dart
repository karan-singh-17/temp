import 'package:flutter_test/flutter_test.dart';
import 'package:nineti_heimspeicher/src/model/model.dart';
import 'package:nineti_heimspeicher/src/model/protobuf/wifi_provisioning_from_device.pb.dart'
    as pb;

void main() {
  group('WiFiUpdate', () {
    final entry1 = pb.WiFiScanEntry(
      ssid: "HELLO",
      bssid: [1, 2, 3, 4, 5],
      needsPassword: true,
      signalStrength: 1337,
    );

    final entry2 = pb.WiFiScanEntry(
      ssid: "Bye",
      bssid: [],
      needsPassword: false,
      signalStrength: 1337,
    );

    final scanResults = pb.WiFiScanResults(wifiScanEntries: [entry1, entry2]);

    final wifiUpdate = pb.WiFiUpdate(wifiScanResults: scanResults);

    test("Can be converted from protobuf", () {
      expect(
        wifiUpdate.toModel(),
        WifiScanResults(
          entries: [entry1.toModel(), entry2.toModel()],
        ),
      );
    });
  });
}