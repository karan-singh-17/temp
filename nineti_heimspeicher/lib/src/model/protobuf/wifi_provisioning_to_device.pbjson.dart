//
//  Generated code. Do not modify.
//  source: wifi_provisioning_to_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use connectDescriptor instead')
const Connect$json = {
  '1': 'Connect',
  '2': [
    {'1': 'connect_args', '3': 1, '4': 2, '5': 11, '6': '.to_device.ConnectArgs', '10': 'connectArgs'},
  ],
};

/// Descriptor for `Connect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectDescriptor = $convert.base64Decode(
    'CgdDb25uZWN0EjkKDGNvbm5lY3RfYXJncxgBIAIoCzIWLnRvX2RldmljZS5Db25uZWN0QXJnc1'
    'ILY29ubmVjdEFyZ3M=');

@$core.Deprecated('Use connectArgsDescriptor instead')
const ConnectArgs$json = {
  '1': 'ConnectArgs',
  '2': [
    {'1': 'ssid', '3': 1, '4': 2, '5': 9, '10': 'ssid'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `ConnectArgs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectArgsDescriptor = $convert.base64Decode(
    'CgtDb25uZWN0QXJncxISCgRzc2lkGAEgAigJUgRzc2lkEhoKCHBhc3N3b3JkGAIgASgJUghwYX'
    'Nzd29yZA==');

@$core.Deprecated('Use disconnectDescriptor instead')
const Disconnect$json = {
  '1': 'Disconnect',
};

/// Descriptor for `Disconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectDescriptor = $convert.base64Decode(
    'CgpEaXNjb25uZWN0');

@$core.Deprecated('Use scanDescriptor instead')
const Scan$json = {
  '1': 'Scan',
};

/// Descriptor for `Scan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanDescriptor = $convert.base64Decode(
    'CgRTY2Fu');

@$core.Deprecated('Use getWiFiStatusDescriptor instead')
const GetWiFiStatus$json = {
  '1': 'GetWiFiStatus',
};

/// Descriptor for `GetWiFiStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWiFiStatusDescriptor = $convert.base64Decode(
    'Cg1HZXRXaUZpU3RhdHVz');

@$core.Deprecated('Use wiFiMessageDescriptor instead')
const WiFiMessage$json = {
  '1': 'WiFiMessage',
  '2': [
    {'1': 'connect', '3': 1, '4': 1, '5': 11, '6': '.to_device.Connect', '9': 0, '10': 'connect'},
    {'1': 'disconnect', '3': 2, '4': 1, '5': 11, '6': '.to_device.Disconnect', '9': 0, '10': 'disconnect'},
    {'1': 'scan', '3': 3, '4': 1, '5': 11, '6': '.to_device.Scan', '9': 0, '10': 'scan'},
    {'1': 'wifi_status', '3': 4, '4': 1, '5': 11, '6': '.to_device.GetWiFiStatus', '9': 0, '10': 'wifiStatus'},
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `WiFiMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiMessageDescriptor = $convert.base64Decode(
    'CgtXaUZpTWVzc2FnZRIuCgdjb25uZWN0GAEgASgLMhIudG9fZGV2aWNlLkNvbm5lY3RIAFIHY2'
    '9ubmVjdBI3CgpkaXNjb25uZWN0GAIgASgLMhUudG9fZGV2aWNlLkRpc2Nvbm5lY3RIAFIKZGlz'
    'Y29ubmVjdBIlCgRzY2FuGAMgASgLMg8udG9fZGV2aWNlLlNjYW5IAFIEc2NhbhI7Cgt3aWZpX3'
    'N0YXR1cxgEIAEoCzIYLnRvX2RldmljZS5HZXRXaUZpU3RhdHVzSABSCndpZmlTdGF0dXNCCQoH'
    'bWVzc2FnZQ==');

