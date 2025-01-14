//
//  Generated code. Do not modify.
//  source: cloud_provisioning_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use provisioningStatusDescriptor instead')
const ProvisioningStatus$json = {
  '1': 'ProvisioningStatus',
  '2': [
    {'1': 'PROVISIONING_STATUS_UNKNOWN', '2': 0},
    {'1': 'PROVISIONING_STATUS_UNPROVISIONED', '2': 1},
    {'1': 'PROVISIONING_STATUS_PROVISIONED', '2': 2},
    {'1': 'PROVISIONING_STATUS_PROVISIONING', '2': 3},
    {'1': 'PROVISIONING_STATUS_PROVISIONING_FAILED', '2': 4},
  ],
};

/// Descriptor for `ProvisioningStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List provisioningStatusDescriptor = $convert.base64Decode(
    'ChJQcm92aXNpb25pbmdTdGF0dXMSHwobUFJPVklTSU9OSU5HX1NUQVRVU19VTktOT1dOEAASJQ'
    'ohUFJPVklTSU9OSU5HX1NUQVRVU19VTlBST1ZJU0lPTkVEEAESIwofUFJPVklTSU9OSU5HX1NU'
    'QVRVU19QUk9WSVNJT05FRBACEiQKIFBST1ZJU0lPTklOR19TVEFUVVNfUFJPVklTSU9OSU5HEA'
    'MSKwonUFJPVklTSU9OSU5HX1NUQVRVU19QUk9WSVNJT05JTkdfRkFJTEVEEAQ=');

@$core.Deprecated('Use cloudProvisioningUpdateDescriptor instead')
const CloudProvisioningUpdate$json = {
  '1': 'CloudProvisioningUpdate',
  '2': [
    {'1': 'provisioning_status', '3': 1, '4': 1, '5': 14, '6': '.from_device.ProvisioningStatus', '9': 0, '10': 'provisioningStatus'},
  ],
  '8': [
    {'1': 'update'},
  ],
};

/// Descriptor for `CloudProvisioningUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudProvisioningUpdateDescriptor = $convert.base64Decode(
    'ChdDbG91ZFByb3Zpc2lvbmluZ1VwZGF0ZRJSChNwcm92aXNpb25pbmdfc3RhdHVzGAEgASgOMh'
    '8uZnJvbV9kZXZpY2UuUHJvdmlzaW9uaW5nU3RhdHVzSABSEnByb3Zpc2lvbmluZ1N0YXR1c0II'
    'CgZ1cGRhdGU=');

