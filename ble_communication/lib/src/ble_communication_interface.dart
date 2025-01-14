import 'dart:async';
import 'dart:typed_data';

abstract class DuplexCommunication
    implements Stream<Uint8List>, StreamSink<List<int>> {}
