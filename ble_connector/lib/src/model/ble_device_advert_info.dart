import 'package:ble_connector/ble_connector.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ble_device_advert_info.g.dart';

@immutable
@JsonSerializable()
class BLEDeviceAdvertInfo extends Equatable {
  const BLEDeviceAdvertInfo({
    required this.name,
    required this.id,
    this.manufacturerData = const [],
  });

  factory BLEDeviceAdvertInfo.fromJson(Map<String, dynamic> json) =>
      _$BLEDeviceAdvertInfoFromJson(json);

  final String name;

  final DeviceId id;

  final List<int> manufacturerData;

  Map<String, dynamic> toJson() => _$BLEDeviceAdvertInfoToJson(this);

  @override
  List<Object?> get props => [
        name,
        id,
        manufacturerData,
      ];
}
