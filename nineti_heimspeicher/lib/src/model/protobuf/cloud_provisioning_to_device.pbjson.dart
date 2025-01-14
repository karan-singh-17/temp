//
//  Generated code. Do not modify.
//  source: cloud_provisioning_to_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cloudProvisioningMessageDescriptor instead')
const CloudProvisioningMessage$json = {
  '1': 'CloudProvisioningMessage',
  '2': [
    {'1': 'provision_device', '3': 1, '4': 1, '5': 11, '6': '.to_device.ProvisionDevice', '9': 0, '10': 'provisionDevice'},
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `CloudProvisioningMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudProvisioningMessageDescriptor = $convert.base64Decode(
    'ChhDbG91ZFByb3Zpc2lvbmluZ01lc3NhZ2USRwoQcHJvdmlzaW9uX2RldmljZRgBIAEoCzIaLn'
    'RvX2RldmljZS5Qcm92aXNpb25EZXZpY2VIAFIPcHJvdmlzaW9uRGV2aWNlQgkKB21lc3NhZ2U=');

@$core.Deprecated('Use provisionDeviceDescriptor instead')
const ProvisionDevice$json = {
  '1': 'ProvisionDevice',
  '2': [
    {'1': 'provisioning_data', '3': 1, '4': 2, '5': 12, '10': 'provisioningData'},
  ],
};

/// Descriptor for `ProvisionDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provisionDeviceDescriptor = $convert.base64Decode(
    'Cg9Qcm92aXNpb25EZXZpY2USKwoRcHJvdmlzaW9uaW5nX2RhdGEYASACKAxSEHByb3Zpc2lvbm'
    'luZ0RhdGE=');

