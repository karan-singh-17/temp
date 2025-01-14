import 'dart:async';
import 'dart:typed_data';
import 'package:ble_communication/src/ble_communication_interface.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class BLERawDataStreamEndpoint
    with Stream<Uint8List>
    implements DuplexCommunication {
  final BLEDevice _device;
  final BLEEndpoint _writeEndpoint;
  final BLEEndpoint _notifyEndpoint;
  final PublishSubject<Uint8List> _receiveStream = PublishSubject();
  final PublishSubject<List<int>> _sendStream = PublishSubject();

  final _log = Logger();
  late final StreamSubscription _deviceStateSubscription;
  late final StreamSubscription _notifySubscription;

  bool get _isClosed => _receiveStream.isClosed;

  BLERawDataStreamEndpoint({
    required BLEDevice device,
    required BLEEndpoint writeEndpoint,
    BLEEndpoint? notifyEndpoint,
  })  : _device = device,
        _writeEndpoint = writeEndpoint,
        _notifyEndpoint = notifyEndpoint ?? writeEndpoint {
    if (_device.connectionState.value != BLEConnectionState.connected) {
      throw ArgumentError("Device must be connected");
    }

    _deviceStateSubscription = _device.connectionState
        .where((state) => state != BLEConnectionState.connected)
        .listen(_onDisconnected);

    _notifySubscription = _device
        .subscribe(_notifyEndpoint)
        .map(Uint8List.fromList)
        .listen(_receiveStream.add);

    _sendEvents();
  }

  Future<void> _sendEvents() async {
    try {
      await for (final data in _sendStream) {
        await _send(data);
      }
    } catch (e, stackTrace) {
      _receiveStream.addError(e, stackTrace);

      await close();

      _log.e(
        "Error writing data",
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _onDisconnected(_) {
    close();
    _receiveStream.close();
  }

  FutureOr<void> _send(List<int> data) {
    if (_isClosed) {
      throw StateError("Communication is closed");
    }

    _log.d('Writing to endpoint: $_writeEndpoint; data: $data ');
    return _device.writeWithResponse(
      endpoint: _writeEndpoint,
      data: data,
    );
  }

  @override
  Future<dynamic> close() async {
    await _receiveStream.close();
    await _notifySubscription.cancel();
    await _deviceStateSubscription.cancel();
    await _sendStream.close();
    _log.i("closed");
  }

  @override
  StreamSubscription<Uint8List> listen(
    void Function(Uint8List event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _receiveStream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  @override
  void add(List<int> event) => _sendStream.add(event);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _sendStream.addError(error, stackTrace);

  @override
  Future<void> addStream(Stream<List<int>> stream) =>
      _sendStream.addStream(stream);

  @override
  Future get done => _sendStream.done;
}
