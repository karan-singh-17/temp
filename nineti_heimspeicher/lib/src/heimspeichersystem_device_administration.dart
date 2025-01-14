import 'dart:async';

import 'package:logger/logger.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:rxdart/rxdart.dart';

class HeimspeichersystemDeviceAdministration {
  late final void Function(DeviceAdministrationMessage) _send;
  final Stream<DeviceAdministrationUpdate> _receiveStream;

  final _log = Logger();
  late final ValueStream<DeviceState> deviceState;

  HeimspeichersystemDeviceAdministration({
    required Stream<DeviceAdministrationUpdate> receiveStream,
    required void Function(DeviceAdministrationMessage) send,
    Duration? scanTimeout,
  })  : _receiveStream = receiveStream.asBroadcastStream(),
        _send = send {
    deviceState = ValueConnectableStream.seeded(
      _receiveStream.whereType<DeviceState>(),
      DeviceState.unknown,
    )..connect();
  }

  FirmwareUpgrade createFirmwareUgrade(String bundleUri) {
    return FirmwareUpgrade(
      uri: bundleUri,
      deviceState: deviceState,
      receiveStream: _receiveStream,
      send: _send,
    );
  }

  Future<List<FirmwareSlotInformation>> getSlotStates({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    _log.i("Requesting slot states");
    _send(GetSlotStates());
    return _receiveStream
        .whereType<SlotStates>()
        .map((update) => update.slots)
        .first
        .timeout(timeout);
  }

  void rebootDevice() {
    _log.i("Rebooting device");
    _send(RebootDevice());
  }

  Future<void> close() async {
    // Nothing to do here
  }
}
