//
//  Generated code. Do not modify.
//  source: rauc_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DeviceState extends $pb.ProtobufEnum {
  static const DeviceState IDLE = DeviceState._(0, _omitEnumNames ? '' : 'IDLE');
  static const DeviceState INSTALLING = DeviceState._(1, _omitEnumNames ? '' : 'INSTALLING');

  static const $core.List<DeviceState> values = <DeviceState> [
    IDLE,
    INSTALLING,
  ];

  static final $core.Map<$core.int, DeviceState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeviceState? valueOf($core.int value) => _byValue[value];

  const DeviceState._($core.int v, $core.String n) : super(v, n);
}

class SlotStatus extends $pb.ProtobufEnum {
  static const SlotStatus booted = SlotStatus._(1, _omitEnumNames ? '' : 'booted');
  static const SlotStatus inactive = SlotStatus._(2, _omitEnumNames ? '' : 'inactive');
  static const SlotStatus active = SlotStatus._(3, _omitEnumNames ? '' : 'active');

  static const $core.List<SlotStatus> values = <SlotStatus> [
    booted,
    inactive,
    active,
  ];

  static final $core.Map<$core.int, SlotStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SlotStatus? valueOf($core.int value) => _byValue[value];

  const SlotStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
