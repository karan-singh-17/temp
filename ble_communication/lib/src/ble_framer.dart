import 'dart:async';
import 'dart:typed_data';
import 'package:ble_communication/src/ble_communication_interface.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class BLEFramer with Stream<Uint8List> implements DuplexCommunication {
  final DuplexCommunication _lowerLayer;
  final _log = Logger();

  final PublishSubject<Uint8List> _receiveStream = PublishSubject();
  late final StreamSubscription? _receiveSubscription;

  final PublishSubject<List<int>> _sendStream = PublishSubject();

  final List<int> _receiveBuffer = [];

  BLEFramer({
    required DuplexCommunication lowerLayer,
  }) : _lowerLayer = lowerLayer {
    _receiveSubscription = _lowerLayer.listen(_onReceiveData);
    _sendEvents();
  }

  Future<void> _sendEvents() async {
    try {
      await for (final data in _sendStream) {
        await _write(data);
      }
    } catch (e, stackTrace) {
      _lowerLayer.addError(e, stackTrace);
      await close();

      _log.e(
        "Error writing data",
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Write a package
  FutureOr<void> _write(List<int> package) async {
    final bufferLenth = package.length;

    final lengthEncoding = Uint8List(4);
    final bufferLengthBytes = ByteData(4)
      ..setUint32(0, bufferLenth, Endian.little);
    lengthEncoding.setRange(0, 4, bufferLengthBytes.buffer.asUint8List());

    final bytes = Uint8List.fromList(lengthEncoding + package);

    _log.d('Framed package: $bytes; raw package: $package');
    return _lowerLayer.add(bytes);
  }

  @override
  Future<void> close() async {
    await _receiveSubscription?.cancel();
    await _lowerLayer.close();
    await _sendStream.close();
    _log.i("closed");
  }

  int _getPackageLength(List<int> data, {bool removeFromData = false}) {
    final length = ByteData.sublistView(Uint8List.fromList(data.sublist(0, 4)))
        .getUint32(0, Endian.little);

    if (removeFromData) {
      data.removeRange(0, 4);
    }

    return length;
  }

  bool _canCreatePackage(List<int> data) {
    if (data.length < 4) {
      return false;
    }

    final length = _getPackageLength(data);

    if (data.sublist(4).length >= length) {
      return true;
    }

    return false;
  }

  List<int> _createPackage(List<int> data, int length) {
    final package = _receiveBuffer.sublist(0, length).toList();
    _receiveBuffer.removeRange(0, length);
    return package;
  }

  void _onReceiveData(List<int> data) {
    _receiveBuffer.addAll(data);

    while (_canCreatePackage(_receiveBuffer)) {
      final length = _getPackageLength(_receiveBuffer, removeFromData: true);
      final package = _createPackage(_receiveBuffer, length);
      _log.d("Received package: $package");
      _receiveStream.add(Uint8List.fromList(package));
    }
  }

  @override
  void add(List<int> event) {
    _sendStream.add(event);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _sendStream.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _sendStream.addStream(stream);

  @override
  Future get done => _sendStream.done;

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
}
