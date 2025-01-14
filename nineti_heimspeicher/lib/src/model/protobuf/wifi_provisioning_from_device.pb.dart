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

import 'wifi_provisioning_from_device.pbenum.dart';

export 'wifi_provisioning_from_device.pbenum.dart';

enum WiFiUpdate_Update {
  wifiStatus, 
  wifiScanResults, 
  notSet
}

class WiFiUpdate extends $pb.GeneratedMessage {
  factory WiFiUpdate({
    WiFiStatus? wifiStatus,
    WiFiScanResults? wifiScanResults,
  }) {
    final $result = create();
    if (wifiStatus != null) {
      $result.wifiStatus = wifiStatus;
    }
    if (wifiScanResults != null) {
      $result.wifiScanResults = wifiScanResults;
    }
    return $result;
  }
  WiFiUpdate._() : super();
  factory WiFiUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WiFiUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, WiFiUpdate_Update> _WiFiUpdate_UpdateByTag = {
    1 : WiFiUpdate_Update.wifiStatus,
    2 : WiFiUpdate_Update.wifiScanResults,
    0 : WiFiUpdate_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WiFiUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..e<WiFiStatus>(1, _omitFieldNames ? '' : 'wifiStatus', $pb.PbFieldType.OE, defaultOrMaker: WiFiStatus.DISCONNECTED, valueOf: WiFiStatus.valueOf, enumValues: WiFiStatus.values)
    ..aOM<WiFiScanResults>(2, _omitFieldNames ? '' : 'wifiScanResults', subBuilder: WiFiScanResults.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WiFiUpdate clone() => WiFiUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WiFiUpdate copyWith(void Function(WiFiUpdate) updates) => super.copyWith((message) => updates(message as WiFiUpdate)) as WiFiUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WiFiUpdate create() => WiFiUpdate._();
  WiFiUpdate createEmptyInstance() => create();
  static $pb.PbList<WiFiUpdate> createRepeated() => $pb.PbList<WiFiUpdate>();
  @$core.pragma('dart2js:noInline')
  static WiFiUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WiFiUpdate>(create);
  static WiFiUpdate? _defaultInstance;

  WiFiUpdate_Update whichUpdate() => _WiFiUpdate_UpdateByTag[$_whichOneof(0)]!;
  void clearUpdate() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  WiFiStatus get wifiStatus => $_getN(0);
  @$pb.TagNumber(1)
  set wifiStatus(WiFiStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasWifiStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearWifiStatus() => clearField(1);

  @$pb.TagNumber(2)
  WiFiScanResults get wifiScanResults => $_getN(1);
  @$pb.TagNumber(2)
  set wifiScanResults(WiFiScanResults v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasWifiScanResults() => $_has(1);
  @$pb.TagNumber(2)
  void clearWifiScanResults() => clearField(2);
  @$pb.TagNumber(2)
  WiFiScanResults ensureWifiScanResults() => $_ensure(1);
}

class WiFiScanResults extends $pb.GeneratedMessage {
  factory WiFiScanResults({
    $core.Iterable<WiFiScanEntry>? wifiScanEntries,
  }) {
    final $result = create();
    if (wifiScanEntries != null) {
      $result.wifiScanEntries.addAll(wifiScanEntries);
    }
    return $result;
  }
  WiFiScanResults._() : super();
  factory WiFiScanResults.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WiFiScanResults.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WiFiScanResults', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..pc<WiFiScanEntry>(1, _omitFieldNames ? '' : 'wifiScanEntries', $pb.PbFieldType.PM, subBuilder: WiFiScanEntry.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WiFiScanResults clone() => WiFiScanResults()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WiFiScanResults copyWith(void Function(WiFiScanResults) updates) => super.copyWith((message) => updates(message as WiFiScanResults)) as WiFiScanResults;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WiFiScanResults create() => WiFiScanResults._();
  WiFiScanResults createEmptyInstance() => create();
  static $pb.PbList<WiFiScanResults> createRepeated() => $pb.PbList<WiFiScanResults>();
  @$core.pragma('dart2js:noInline')
  static WiFiScanResults getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WiFiScanResults>(create);
  static WiFiScanResults? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<WiFiScanEntry> get wifiScanEntries => $_getList(0);
}

class WiFiScanEntry extends $pb.GeneratedMessage {
  factory WiFiScanEntry({
    $core.String? ssid,
    $core.int? signalStrength,
    $core.Iterable<$core.int>? bssid,
    $core.bool? needsPassword,
  }) {
    final $result = create();
    if (ssid != null) {
      $result.ssid = ssid;
    }
    if (signalStrength != null) {
      $result.signalStrength = signalStrength;
    }
    if (bssid != null) {
      $result.bssid.addAll(bssid);
    }
    if (needsPassword != null) {
      $result.needsPassword = needsPassword;
    }
    return $result;
  }
  WiFiScanEntry._() : super();
  factory WiFiScanEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WiFiScanEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WiFiScanEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'ssid')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'signalStrength', $pb.PbFieldType.Q3)
    ..p<$core.int>(3, _omitFieldNames ? '' : 'bssid', $pb.PbFieldType.PU3)
    ..a<$core.bool>(4, _omitFieldNames ? '' : 'needsPassword', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WiFiScanEntry clone() => WiFiScanEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WiFiScanEntry copyWith(void Function(WiFiScanEntry) updates) => super.copyWith((message) => updates(message as WiFiScanEntry)) as WiFiScanEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WiFiScanEntry create() => WiFiScanEntry._();
  WiFiScanEntry createEmptyInstance() => create();
  static $pb.PbList<WiFiScanEntry> createRepeated() => $pb.PbList<WiFiScanEntry>();
  @$core.pragma('dart2js:noInline')
  static WiFiScanEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WiFiScanEntry>(create);
  static WiFiScanEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ssid => $_getSZ(0);
  @$pb.TagNumber(1)
  set ssid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSsid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSsid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get signalStrength => $_getIZ(1);
  @$pb.TagNumber(2)
  set signalStrength($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSignalStrength() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignalStrength() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get bssid => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get needsPassword => $_getBF(3);
  @$pb.TagNumber(4)
  set needsPassword($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNeedsPassword() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeedsPassword() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
