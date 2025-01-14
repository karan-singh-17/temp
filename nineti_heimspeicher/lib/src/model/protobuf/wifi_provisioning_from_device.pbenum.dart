//
//  Generated code. Do not modify.
//  source: wifi_provisioning_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class WiFiStatus extends $pb.ProtobufEnum {
  static const WiFiStatus DISCONNECTED = WiFiStatus._(0, _omitEnumNames ? '' : 'DISCONNECTED');
  static const WiFiStatus SCANNING = WiFiStatus._(1, _omitEnumNames ? '' : 'SCANNING');
  static const WiFiStatus CONNECTING = WiFiStatus._(2, _omitEnumNames ? '' : 'CONNECTING');
  static const WiFiStatus CONNECTED = WiFiStatus._(3, _omitEnumNames ? '' : 'CONNECTED');
  static const WiFiStatus UNKNOWN = WiFiStatus._(4, _omitEnumNames ? '' : 'UNKNOWN');

  static const $core.List<WiFiStatus> values = <WiFiStatus> [
    DISCONNECTED,
    SCANNING,
    CONNECTING,
    CONNECTED,
    UNKNOWN,
  ];

  static final $core.Map<$core.int, WiFiStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WiFiStatus? valueOf($core.int value) => _byValue[value];

  const WiFiStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
