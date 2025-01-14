import 'package:flutter_test/flutter_test.dart';
import 'package:nineti_heimspeicher/src/model/model.dart';
import 'package:nineti_heimspeicher/src/model/protobuf/wifi_provisioning_from_device.pb.dart'
    as pb;

void main() {
  group('WiFiScanEntry', () {
    final entry = pb.WiFiScanEntry(
        ssid: "HELLO",
        bssid: [1, 2, 3, 4, 5],
        needsPassword: true,
        signalStrength: 1337);

    test('can be instanciated', () {
      expect(
        WiFiScanEntry(
            bssid: [], signalStrength: 0, ssid: "", needsPassword: false),
        isA<WiFiScanEntry>(),
      );
    });

    test("Can be converted from protobuf", () {
      expect(
        entry.toModel(),
        WiFiScanEntry(
          ssid: entry.ssid,
          signalStrength: entry.signalStrength,
          bssid: entry.bssid,
          needsPassword: entry.needsPassword,
        ),
      );
    });
  });
}
