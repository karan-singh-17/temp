import 'dart:async';
import 'dart:typed_data';

class FramedStreamSink implements StreamSink<List<int>> {
  final StreamSink<List<int>> _sink;

  FramedStreamSink(this._sink);

  @override
  void add(List<int> event) {
    final bufferLenth = event.length;

    final lengthEncoding = Uint8List(4);
    final bufferLengthBytes = ByteData(4)
      ..setUint32(0, bufferLenth, Endian.little);
    lengthEncoding.setRange(0, 4, bufferLengthBytes.buffer.asUint8List());

    final bytes = Uint8List.fromList(lengthEncoding + event);
    _sink.add(bytes);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _sink.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) async {
    await for (final event in stream) {
      add(event);
    }
  }

  @override
  Future close() => _sink.close();

  @override
  Future get done => _sink.done;
}
