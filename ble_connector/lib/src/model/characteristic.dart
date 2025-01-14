import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Characteristic extends Equatable {
  Characteristic({
    required String uuid,
    required this.isReadable,
    required this.isWritableWithoutResponse,
    required this.isWritableWithResponse,
    required this.isNotifiable,
    required this.isIndicatable,
  }) : uuid = uuid.toLowerCase();

  final String uuid;
  final bool isReadable;
  final bool isWritableWithoutResponse;
  final bool isWritableWithResponse;
  final bool isNotifiable;
  final bool isIndicatable;

  @override
  List<Object?> get props => [
        uuid,
        isReadable,
        isWritableWithoutResponse,
        isWritableWithResponse,
        isNotifiable,
        isIndicatable,
      ];
}
