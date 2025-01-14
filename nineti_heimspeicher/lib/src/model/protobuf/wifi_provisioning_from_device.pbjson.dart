//
//  Generated code. Do not modify.
//  source: wifi_provisioning_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use wiFiStatusDescriptor instead')
const WiFiStatus$json = {
  '1': 'WiFiStatus',
  '2': [
    {'1': 'DISCONNECTED', '2': 0},
    {'1': 'SCANNING', '2': 1},
    {'1': 'CONNECTING', '2': 2},
    {'1': 'CONNECTED', '2': 3},
    {'1': 'UNKNOWN', '2': 4},
  ],
};

/// Descriptor for `WiFiStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List wiFiStatusDescriptor = $convert.base64Decode(
    'CgpXaUZpU3RhdHVzEhAKDERJU0NPTk5FQ1RFRBAAEgwKCFNDQU5OSU5HEAESDgoKQ09OTkVDVE'
    'lORxACEg0KCUNPTk5FQ1RFRBADEgsKB1VOS05PV04QBA==');

@$core.Deprecated('Use wiFiUpdateDescriptor instead')
const WiFiUpdate$json = {
  '1': 'WiFiUpdate',
  '2': [
    {'1': 'wifi_status', '3': 1, '4': 1, '5': 14, '6': '.from_device.WiFiStatus', '9': 0, '10': 'wifiStatus'},
    {'1': 'wifi_scan_results', '3': 2, '4': 1, '5': 11, '6': '.from_device.WiFiScanResults', '9': 0, '10': 'wifiScanResults'},
  ],
  '8': [
    {'1': 'update'},
  ],
};

/// Descriptor for `WiFiUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiUpdateDescriptor = $convert.base64Decode(
    'CgpXaUZpVXBkYXRlEjoKC3dpZmlfc3RhdHVzGAEgASgOMhcuZnJvbV9kZXZpY2UuV2lGaVN0YX'
    'R1c0gAUgp3aWZpU3RhdHVzEkoKEXdpZmlfc2Nhbl9yZXN1bHRzGAIgASgLMhwuZnJvbV9kZXZp'
    'Y2UuV2lGaVNjYW5SZXN1bHRzSABSD3dpZmlTY2FuUmVzdWx0c0IICgZ1cGRhdGU=');

@$core.Deprecated('Use wiFiScanResultsDescriptor instead')
const WiFiScanResults$json = {
  '1': 'WiFiScanResults',
  '2': [
    {'1': 'wifi_scan_entries', '3': 1, '4': 3, '5': 11, '6': '.from_device.WiFiScanEntry', '10': 'wifiScanEntries'},
  ],
};

/// Descriptor for `WiFiScanResults`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiScanResultsDescriptor = $convert.base64Decode(
    'Cg9XaUZpU2NhblJlc3VsdHMSRgoRd2lmaV9zY2FuX2VudHJpZXMYASADKAsyGi5mcm9tX2Rldm'
    'ljZS5XaUZpU2NhbkVudHJ5Ug93aWZpU2NhbkVudHJpZXM=');

@$core.Deprecated('Use wiFiScanEntryDescriptor instead')
const WiFiScanEntry$json = {
  '1': 'WiFiScanEntry',
  '2': [
    {'1': 'ssid', '3': 1, '4': 2, '5': 9, '10': 'ssid'},
    {'1': 'signal_strength', '3': 2, '4': 2, '5': 5, '10': 'signalStrength'},
    {'1': 'bssid', '3': 3, '4': 3, '5': 13, '10': 'bssid'},
    {'1': 'needs_password', '3': 4, '4': 2, '5': 8, '10': 'needsPassword'},
  ],
};

/// Descriptor for `WiFiScanEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiScanEntryDescriptor = $convert.base64Decode(
    'Cg1XaUZpU2NhbkVudHJ5EhIKBHNzaWQYASACKAlSBHNzaWQSJwoPc2lnbmFsX3N0cmVuZ3RoGA'
    'IgAigFUg5zaWduYWxTdHJlbmd0aBIUCgVic3NpZBgDIAMoDVIFYnNzaWQSJQoObmVlZHNfcGFz'
    'c3dvcmQYBCACKAhSDW5lZWRzUGFzc3dvcmQ=');

