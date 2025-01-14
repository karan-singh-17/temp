//
//  Generated code. Do not modify.
//  source: rauc_to_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use deviceAdministrationMessageDescriptor instead')
const DeviceAdministrationMessage$json = {
  '1': 'DeviceAdministrationMessage',
  '2': [
    {'1': 'install_bundle', '3': 1, '4': 1, '5': 11, '6': '.to_device.InstallBundle', '9': 0, '10': 'installBundle'},
    {'1': 'get_device_state', '3': 2, '4': 1, '5': 11, '6': '.to_device.GetDeviceState', '9': 0, '10': 'getDeviceState'},
    {'1': 'get_slot_states', '3': 3, '4': 1, '5': 11, '6': '.to_device.GetSlotStates', '9': 0, '10': 'getSlotStates'},
    {'1': 'get_bundle_information', '3': 4, '4': 1, '5': 11, '6': '.to_device.GetBundleInformation', '9': 0, '10': 'getBundleInformation'},
    {'1': 'reboot_device', '3': 5, '4': 1, '5': 11, '6': '.to_device.RebootDevice', '9': 0, '10': 'rebootDevice'},
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `DeviceAdministrationMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceAdministrationMessageDescriptor = $convert.base64Decode(
    'ChtEZXZpY2VBZG1pbmlzdHJhdGlvbk1lc3NhZ2USQQoOaW5zdGFsbF9idW5kbGUYASABKAsyGC'
    '50b19kZXZpY2UuSW5zdGFsbEJ1bmRsZUgAUg1pbnN0YWxsQnVuZGxlEkUKEGdldF9kZXZpY2Vf'
    'c3RhdGUYAiABKAsyGS50b19kZXZpY2UuR2V0RGV2aWNlU3RhdGVIAFIOZ2V0RGV2aWNlU3RhdG'
    'USQgoPZ2V0X3Nsb3Rfc3RhdGVzGAMgASgLMhgudG9fZGV2aWNlLkdldFNsb3RTdGF0ZXNIAFIN'
    'Z2V0U2xvdFN0YXRlcxJXChZnZXRfYnVuZGxlX2luZm9ybWF0aW9uGAQgASgLMh8udG9fZGV2aW'
    'NlLkdldEJ1bmRsZUluZm9ybWF0aW9uSABSFGdldEJ1bmRsZUluZm9ybWF0aW9uEj4KDXJlYm9v'
    'dF9kZXZpY2UYBSABKAsyFy50b19kZXZpY2UuUmVib290RGV2aWNlSABSDHJlYm9vdERldmljZU'
    'IJCgdtZXNzYWdl');

@$core.Deprecated('Use installBundleDescriptor instead')
const InstallBundle$json = {
  '1': 'InstallBundle',
  '2': [
    {'1': 'uri', '3': 1, '4': 2, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `InstallBundle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List installBundleDescriptor = $convert.base64Decode(
    'Cg1JbnN0YWxsQnVuZGxlEhAKA3VyaRgBIAIoCVIDdXJp');

@$core.Deprecated('Use getSlotStatesDescriptor instead')
const GetSlotStates$json = {
  '1': 'GetSlotStates',
};

/// Descriptor for `GetSlotStates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSlotStatesDescriptor = $convert.base64Decode(
    'Cg1HZXRTbG90U3RhdGVz');

@$core.Deprecated('Use getDeviceStateDescriptor instead')
const GetDeviceState$json = {
  '1': 'GetDeviceState',
};

/// Descriptor for `GetDeviceState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDeviceStateDescriptor = $convert.base64Decode(
    'Cg5HZXREZXZpY2VTdGF0ZQ==');

@$core.Deprecated('Use getBundleInformationDescriptor instead')
const GetBundleInformation$json = {
  '1': 'GetBundleInformation',
  '2': [
    {'1': 'uri', '3': 1, '4': 2, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `GetBundleInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBundleInformationDescriptor = $convert.base64Decode(
    'ChRHZXRCdW5kbGVJbmZvcm1hdGlvbhIQCgN1cmkYASACKAlSA3VyaQ==');

@$core.Deprecated('Use rebootDeviceDescriptor instead')
const RebootDevice$json = {
  '1': 'RebootDevice',
};

/// Descriptor for `RebootDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rebootDeviceDescriptor = $convert.base64Decode(
    'CgxSZWJvb3REZXZpY2U=');

