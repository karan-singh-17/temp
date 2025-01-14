import 'dart:async';
import 'package:logger/logger.dart';
import 'package:nineti_heimspeicher/src/model/model.dart';
import 'package:rxdart/rxdart.dart';

class FirmwareUpgrade {
  late final void Function(DeviceAdministrationMessage) _send;
  final Stream<DeviceAdministrationUpdate> _receiveStream;

  final _log = Logger();
  final String uri;
  final ValueStream<DeviceState> _deviceState;
  late final StreamSubscription _receivedPackageSubscription;

  bool _updateStarted = false;

  final BehaviorSubject<FirmwareUpgradeState> _state = BehaviorSubject.seeded(
    FirmwareUpgradeState(
      errorMessage: null,
      progress: 0.0,
      resultCode: null,
      status: 'idle',
    ),
  );

  FirmwareUpgrade({
    required Stream<DeviceAdministrationUpdate> receiveStream,
    required void Function(DeviceAdministrationMessage) send,
    required this.uri,
    required ValueStream<DeviceState> deviceState,
  })  : _send = send,
        _receiveStream = receiveStream,
        _deviceState = deviceState {
    _receivedPackageSubscription = receiveStream.listen(_onReceive);

    // Request current operationional state
    send(GetDeviceState());
  }

  ValueStream<FirmwareUpgradeState> get state => _state.stream;
  ValueStream<DeviceState> get deviceState => _deviceState;
  bool get updateStarted => _updateStarted;

  FirmwareUpgrade reset() {
    return FirmwareUpgrade(
      uri: uri,
      deviceState: _deviceState,
      receiveStream: _receiveStream,
      send: _send,
    );
  }

  Future<void> startFirmwareUpdate() async {
    // Forbid starting the update again
    // If an error occurs during the update, it is set in the state
    // and can **not** be removed!
    // Therefore it is safer to create a new instance without the error in state
    if (_updateStarted) {
      throw StateError('Update already started');
    }

    final operationState = _deviceState.value;
    if (operationState != DeviceState.idle) {
      throw StateError(
        'Update requested in operational State "$operationState" != ${DeviceState.idle}',
      );
    }

    _send(InstallBundle(uri: uri));
    _updateStarted = true;
  }

  Future<void> close() async {
    await _receivedPackageSubscription.cancel();
  }

  void _onUpdateComplete(int resultCode) {
    _log.i('Update completed with resultCode: $resultCode');
    _state.add(
      _state.value.copyWith(
        resultCode: () => resultCode,
      ),
    );

    // _state.close();
  }

  void _onUpdateError(String error) {
    _log.w('Received Error from RAUC', error: error);
    _state.add(
      _state.value.copyWith(
        errorMessage: () => error,
      ),
    );
  }

  void _onProgressUpdate({
    required double progress,
    required String status,
  }) {
    _state.add(
      _state.value.copyWith(
        progress: () => progress,
        status: () => status,
      ),
    );
  }

  void _onReceive(DeviceAdministrationUpdate update) {
    _log.i("Received Update: $update");

    if (_state.isClosed) {
      _log.w("State Closed");
      return;
    }

    switch (update) {
      case ProgressUpdate():
        _onProgressUpdate(
          progress: update.progress,
          status: update.status,
        );
        if (update.resultCode != null) {
          _onUpdateComplete(update.resultCode!);
        }
        break;
      case DeviceAdministrationError():
        _onUpdateError(update.message);
      case DeviceState():
        // Fallthrough
        break;
      case SlotStates():
        // Fallthrough
        break;
      case BundleInformation():
        // Fallthrough
        break;
    }
  }
}
