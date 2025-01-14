//
//  Generated code. Do not modify.
//  source: cloud_provisioning_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ProvisioningStatus extends $pb.ProtobufEnum {
  static const ProvisioningStatus PROVISIONING_STATUS_UNKNOWN = ProvisioningStatus._(0, _omitEnumNames ? '' : 'PROVISIONING_STATUS_UNKNOWN');
  static const ProvisioningStatus PROVISIONING_STATUS_UNPROVISIONED = ProvisioningStatus._(1, _omitEnumNames ? '' : 'PROVISIONING_STATUS_UNPROVISIONED');
  static const ProvisioningStatus PROVISIONING_STATUS_PROVISIONED = ProvisioningStatus._(2, _omitEnumNames ? '' : 'PROVISIONING_STATUS_PROVISIONED');
  static const ProvisioningStatus PROVISIONING_STATUS_PROVISIONING = ProvisioningStatus._(3, _omitEnumNames ? '' : 'PROVISIONING_STATUS_PROVISIONING');
  static const ProvisioningStatus PROVISIONING_STATUS_PROVISIONING_FAILED = ProvisioningStatus._(4, _omitEnumNames ? '' : 'PROVISIONING_STATUS_PROVISIONING_FAILED');

  static const $core.List<ProvisioningStatus> values = <ProvisioningStatus> [
    PROVISIONING_STATUS_UNKNOWN,
    PROVISIONING_STATUS_UNPROVISIONED,
    PROVISIONING_STATUS_PROVISIONED,
    PROVISIONING_STATUS_PROVISIONING,
    PROVISIONING_STATUS_PROVISIONING_FAILED,
  ];

  static final $core.Map<$core.int, ProvisioningStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ProvisioningStatus? valueOf($core.int value) => _byValue[value];

  const ProvisioningStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
