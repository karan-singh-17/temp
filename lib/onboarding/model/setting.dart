import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Setting<T> extends Equatable {
  final String key;
  final T defaultValue;

  const Setting({
    required this.key,
    required this.defaultValue,
  });

  @override
  List<Object?> get props => [
        key,
        defaultValue,
      ];
}
