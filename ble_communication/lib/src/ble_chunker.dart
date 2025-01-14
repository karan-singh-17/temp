import 'dart:async';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:ble_communication/ble_communication.dart';

class BLEChunker with Stream<Uint8List> implements DuplexCommunication {
  final DuplexCommunication _lowerLayer;
  final int chunkSize;

  BLEChunker({
    required DuplexCommunication lowerLayer,
    required this.chunkSize,
  }) : _lowerLayer = lowerLayer;

  @override
  void add(List<int> event) {
    if (event.isEmpty) {
      _lowerLayer.add(event);
      return;
    }

    final chunks = _splitInChunks(event);
    for (final chunk in chunks) {
      _lowerLayer.add(chunk);
    }
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    final chunkedStream = stream.map(_splitInChunks);
    final s = chunkedStream.expand<List<int>>((chunks) => chunks);
    return _lowerLayer.addStream(s);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _lowerLayer.addError(error, stackTrace);

  @override
  Future close() {
    return _lowerLayer.close();
  }

  @override
  Future get done => _lowerLayer.done;

  @override
  StreamSubscription<Uint8List> listen(void Function(Uint8List event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _lowerLayer.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  List<List<int>> _splitInChunks(List<int> data) => data
      .splitBeforeIndexed((index, value) => index % chunkSize == 0)
      .toList();
}
