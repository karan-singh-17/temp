//
//  Generated code. Do not modify.
//  source: rauc_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use deviceStateDescriptor instead')
const DeviceState$json = {
  '1': 'DeviceState',
  '2': [
    {'1': 'IDLE', '2': 0},
    {'1': 'INSTALLING', '2': 1},
  ],
};

/// Descriptor for `DeviceState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceStateDescriptor = $convert.base64Decode(
    'CgtEZXZpY2VTdGF0ZRIICgRJRExFEAASDgoKSU5TVEFMTElORxAB');

@$core.Deprecated('Use slotStatusDescriptor instead')
const SlotStatus$json = {
  '1': 'SlotStatus',
  '2': [
    {'1': 'booted', '2': 1},
    {'1': 'inactive', '2': 2},
    {'1': 'active', '2': 3},
  ],
};

/// Descriptor for `SlotStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List slotStatusDescriptor = $convert.base64Decode(
    'CgpTbG90U3RhdHVzEgoKBmJvb3RlZBABEgwKCGluYWN0aXZlEAISCgoGYWN0aXZlEAM=');

@$core.Deprecated('Use progressUpdateDescriptor instead')
const ProgressUpdate$json = {
  '1': 'ProgressUpdate',
  '2': [
    {'1': 'progress', '3': 1, '4': 2, '5': 2, '10': 'progress'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'result_code', '3': 3, '4': 1, '5': 5, '10': 'resultCode'},
  ],
};

/// Descriptor for `ProgressUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List progressUpdateDescriptor = $convert.base64Decode(
    'Cg5Qcm9ncmVzc1VwZGF0ZRIaCghwcm9ncmVzcxgBIAIoAlIIcHJvZ3Jlc3MSFgoGc3RhdHVzGA'
    'IgASgJUgZzdGF0dXMSHwoLcmVzdWx0X2NvZGUYAyABKAVSCnJlc3VsdENvZGU=');

@$core.Deprecated('Use slotStatesDescriptor instead')
const SlotStates$json = {
  '1': 'SlotStates',
  '2': [
    {'1': 'slot_states', '3': 1, '4': 3, '5': 11, '6': '.from_device.SlotState', '10': 'slotStates'},
  ],
};

/// Descriptor for `SlotStates`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slotStatesDescriptor = $convert.base64Decode(
    'CgpTbG90U3RhdGVzEjcKC3Nsb3Rfc3RhdGVzGAEgAygLMhYuZnJvbV9kZXZpY2UuU2xvdFN0YX'
    'RlUgpzbG90U3RhdGVz');

@$core.Deprecated('Use slotStateDescriptor instead')
const SlotState$json = {
  '1': 'SlotState',
  '2': [
    {'1': 'status', '3': 1, '4': 2, '5': 14, '6': '.from_device.SlotStatus', '10': 'status'},
    {'1': 'bundle_hash', '3': 2, '4': 2, '5': 9, '10': 'bundleHash'},
    {'1': 'firmware_version', '3': 3, '4': 2, '5': 9, '10': 'firmwareVersion'},
  ],
};

/// Descriptor for `SlotState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slotStateDescriptor = $convert.base64Decode(
    'CglTbG90U3RhdGUSLwoGc3RhdHVzGAEgAigOMhcuZnJvbV9kZXZpY2UuU2xvdFN0YXR1c1IGc3'
    'RhdHVzEh8KC2J1bmRsZV9oYXNoGAIgAigJUgpidW5kbGVIYXNoEikKEGZpcm13YXJlX3ZlcnNp'
    'b24YAyACKAlSD2Zpcm13YXJlVmVyc2lvbg==');

@$core.Deprecated('Use bundleInformationDescriptor instead')
const BundleInformation$json = {
  '1': 'BundleInformation',
  '2': [
    {'1': 'uri', '3': 1, '4': 2, '5': 9, '10': 'uri'},
    {'1': 'bundle_hash', '3': 2, '4': 2, '5': 9, '10': 'bundleHash'},
    {'1': 'firmware_version', '3': 3, '4': 2, '5': 9, '10': 'firmwareVersion'},
  ],
};

/// Descriptor for `BundleInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleInformationDescriptor = $convert.base64Decode(
    'ChFCdW5kbGVJbmZvcm1hdGlvbhIQCgN1cmkYASACKAlSA3VyaRIfCgtidW5kbGVfaGFzaBgCIA'
    'IoCVIKYnVuZGxlSGFzaBIpChBmaXJtd2FyZV92ZXJzaW9uGAMgAigJUg9maXJtd2FyZVZlcnNp'
    'b24=');

@$core.Deprecated('Use lastErrorDescriptor instead')
const LastError$json = {
  '1': 'LastError',
  '2': [
    {'1': 'message', '3': 1, '4': 2, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LastError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lastErrorDescriptor = $convert.base64Decode(
    'CglMYXN0RXJyb3ISGAoHbWVzc2FnZRgBIAIoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use deviceAdministrationUpdateDescriptor instead')
const DeviceAdministrationUpdate$json = {
  '1': 'DeviceAdministrationUpdate',
  '2': [
    {'1': 'progress', '3': 1, '4': 1, '5': 11, '6': '.from_device.ProgressUpdate', '9': 0, '10': 'progress'},
    {'1': 'device_state', '3': 2, '4': 1, '5': 14, '6': '.from_device.DeviceState', '9': 0, '10': 'deviceState'},
    {'1': 'slot_states', '3': 3, '4': 1, '5': 11, '6': '.from_device.SlotStates', '9': 0, '10': 'slotStates'},
    {'1': 'bundle_information', '3': 4, '4': 1, '5': 11, '6': '.from_device.BundleInformation', '9': 0, '10': 'bundleInformation'},
    {'1': 'error', '3': 5, '4': 1, '5': 11, '6': '.from_device.LastError', '9': 0, '10': 'error'},
  ],
  '8': [
    {'1': 'update'},
  ],
};

/// Descriptor for `DeviceAdministrationUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceAdministrationUpdateDescriptor = $convert.base64Decode(
    'ChpEZXZpY2VBZG1pbmlzdHJhdGlvblVwZGF0ZRI5Cghwcm9ncmVzcxgBIAEoCzIbLmZyb21fZG'
    'V2aWNlLlByb2dyZXNzVXBkYXRlSABSCHByb2dyZXNzEj0KDGRldmljZV9zdGF0ZRgCIAEoDjIY'
    'LmZyb21fZGV2aWNlLkRldmljZVN0YXRlSABSC2RldmljZVN0YXRlEjoKC3Nsb3Rfc3RhdGVzGA'
    'MgASgLMhcuZnJvbV9kZXZpY2UuU2xvdFN0YXRlc0gAUgpzbG90U3RhdGVzEk8KEmJ1bmRsZV9p'
    'bmZvcm1hdGlvbhgEIAEoCzIeLmZyb21fZGV2aWNlLkJ1bmRsZUluZm9ybWF0aW9uSABSEWJ1bm'
    'RsZUluZm9ybWF0aW9uEi4KBWVycm9yGAUgASgLMhYuZnJvbV9kZXZpY2UuTGFzdEVycm9ySABS'
    'BWVycm9yQggKBnVwZGF0ZQ==');

