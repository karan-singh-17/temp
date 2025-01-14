// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_device_advert_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BLEDeviceAdvertInfo _$BLEDeviceAdvertInfoFromJson(Map<String, dynamic> json) =>
    BLEDeviceAdvertInfo(
      name: json['name'] as String,
      id: json['id'] as String,
      manufacturerData: (json['manufacturerData'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BLEDeviceAdvertInfoToJson(
        BLEDeviceAdvertInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'manufacturerData': instance.manufacturerData,
    };
