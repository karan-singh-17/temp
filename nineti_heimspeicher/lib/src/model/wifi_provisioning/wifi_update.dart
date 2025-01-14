part of 'wifi_provisioning.dart';

sealed class WiFiUpdate extends Equatable {
  const WiFiUpdate();
}

extension WiFiUpdateToModel on from_pb.WiFiUpdate {
  WiFiUpdate toModel() {
    switch (whichUpdate()) {
      case from_pb.WiFiUpdate_Update.wifiStatus:
        return wifiStatus.toModel();
      case from_pb.WiFiUpdate_Update.wifiScanResults:
        return wifiScanResults.toModel();
      case from_pb.WiFiUpdate_Update.notSet:
        // fallthrough
        break;
    }

    throw Exception("Can not convert WiFiUpdate to model: $this");
  }
}

extension WiFiUpdateFromBuffer on WiFiUpdate {
  static WiFiUpdate fromBuffer(List<int> buffer) {
    return from_pb.WiFiUpdate.fromBuffer(buffer).toModel();
  }
}
