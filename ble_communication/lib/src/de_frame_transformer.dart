import 'dart:async';
import 'dart:typed_data';

class DeFrameTransformer extends StreamTransformerBase<Uint8List, Uint8List> {
  final _receiveBuffer = <int>[];

  int getPackageLength(List<int> data, {bool removeFromData = false}) {
    final length = ByteData.sublistView(Uint8List.fromList(data.sublist(0, 4)))
        .getUint32(0, Endian.little);

    if (removeFromData) {
      data.removeRange(0, 4);
    }

    return length;
  }

  bool canCreatePackage(List<int> data) {
    if (data.length < 4) {
      return false;
    }

    final length = getPackageLength(data);

    if (data.sublist(4).length >= length) {
      return true;
    }

    return false;
  }

  List<int> createPackage(List<int> data, int length) {
    final package = _receiveBuffer.sublist(0, length).toList();
    _receiveBuffer.removeRange(0, length);
    return package;
  }

  Stream<Uint8List> _processRawData(List<int> data) async* {
    _receiveBuffer.addAll(data);
    while (canCreatePackage(_receiveBuffer)) {
      final length = getPackageLength(_receiveBuffer, removeFromData: true);
      final package = createPackage(_receiveBuffer, length);
      yield Uint8List.fromList(package);
    }
  }

  @override
  Stream<Uint8List> bind(Stream<Uint8List> stream) async* {
    await for (final data in stream) {
      yield* _processRawData(data);
    }
  }
}
