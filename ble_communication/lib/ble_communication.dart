/// Abstraction of the communication layer the Bluetooth communication.
///
/// Hides Encryption, framing ,etc.
library;

export 'src/ble_communication_interface.dart';
export 'src/ble_raw_datastream_endpoint.dart';
export 'src/ble_framer.dart';
export 'src/framed_stream_sink.dart';
export 'src/de_frame_transformer.dart';
export 'src/ble_chunker.dart';
