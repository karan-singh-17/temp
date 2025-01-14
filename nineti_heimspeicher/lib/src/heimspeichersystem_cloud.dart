import 'dart:async';
import 'dart:typed_data';

import 'package:nineti_heimspeicher/src/model/cloud_provisioning/cloud_provisioning.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class HeimspeichersystemCloud {
  final Logger _log = Logger();

  late final void Function(CloudProvisioningMessage) _send;

  final Stream<CloudProvisioningUpdate> _receiveStream;

  final BehaviorSubject<CloudProvisioningStatus> _status =
      BehaviorSubject<CloudProvisioningStatus>.seeded(
          CloudProvisioningStatus.unknown);

  late final StreamSubscription _receivedPackageSubscription;

  HeimspeichersystemCloud({
    required Stream<CloudProvisioningUpdate> receiveStream,
    required void Function(CloudProvisioningMessage) send,
  })  : _receiveStream = receiveStream,
        _send = send {
    _receivedPackageSubscription = _receiveStream.listen(_onReceive);
  }

  ValueStream<CloudProvisioningStatus> get status => _status.stream;

  void provisiongDevice(Uint8List provisioningData) {
    _log.i('Provisioning Device with data: $provisioningData');
    _send(ProvisionDeviceWithCloudData(provisionData: provisioningData));
  }

  Future<void> close() async {
    await _receivedPackageSubscription.cancel();
    _log.i("closed");
  }

  void _onReceive(CloudProvisioningUpdate update) {
    _log.d("Parsed package: $update");
    switch (update) {
      case CloudProvisioningStatus():
        _onStatus(update);
        break;
    }
  }

  void _onStatus(CloudProvisioningStatus currentStatus) {
    _status.add(currentStatus);
  }
}
