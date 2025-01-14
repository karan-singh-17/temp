import 'package:ble_connector/ble_connector.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Service extends Equatable {
  Service({
    required String uuid,
    required this.characteristics,
  }) : uuid = uuid.toLowerCase();

  final String uuid;
  final List<Characteristic> characteristics;

  @override
  List<Object?> get props => [
        uuid,
        characteristics,
      ];
}
