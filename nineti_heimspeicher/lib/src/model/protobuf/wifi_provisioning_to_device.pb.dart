//
//  Generated code. Do not modify.
//  source: wifi_provisioning_to_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Connect extends $pb.GeneratedMessage {
  factory Connect({
    ConnectArgs? connectArgs,
  }) {
    final $result = create();
    if (connectArgs != null) {
      $result.connectArgs = connectArgs;
    }
    return $result;
  }
  Connect._() : super();
  factory Connect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Connect', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..aQM<ConnectArgs>(1, _omitFieldNames ? '' : 'connectArgs', subBuilder: ConnectArgs.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connect clone() => Connect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connect copyWith(void Function(Connect) updates) => super.copyWith((message) => updates(message as Connect)) as Connect;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Connect create() => Connect._();
  Connect createEmptyInstance() => create();
  static $pb.PbList<Connect> createRepeated() => $pb.PbList<Connect>();
  @$core.pragma('dart2js:noInline')
  static Connect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Connect>(create);
  static Connect? _defaultInstance;

  @$pb.TagNumber(1)
  ConnectArgs get connectArgs => $_getN(0);
  @$pb.TagNumber(1)
  set connectArgs(ConnectArgs v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasConnectArgs() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectArgs() => clearField(1);
  @$pb.TagNumber(1)
  ConnectArgs ensureConnectArgs() => $_ensure(0);
}

class ConnectArgs extends $pb.GeneratedMessage {
  factory ConnectArgs({
    $core.String? ssid,
    $core.String? password,
  }) {
    final $result = create();
    if (ssid != null) {
      $result.ssid = ssid;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  ConnectArgs._() : super();
  factory ConnectArgs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectArgs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectArgs', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'ssid')
    ..aOS(2, _omitFieldNames ? '' : 'password')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectArgs clone() => ConnectArgs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectArgs copyWith(void Function(ConnectArgs) updates) => super.copyWith((message) => updates(message as ConnectArgs)) as ConnectArgs;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectArgs create() => ConnectArgs._();
  ConnectArgs createEmptyInstance() => create();
  static $pb.PbList<ConnectArgs> createRepeated() => $pb.PbList<ConnectArgs>();
  @$core.pragma('dart2js:noInline')
  static ConnectArgs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectArgs>(create);
  static ConnectArgs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ssid => $_getSZ(0);
  @$pb.TagNumber(1)
  set ssid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSsid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSsid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class Disconnect extends $pb.GeneratedMessage {
  factory Disconnect() => create();
  Disconnect._() : super();
  factory Disconnect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Disconnect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Disconnect', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Disconnect clone() => Disconnect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Disconnect copyWith(void Function(Disconnect) updates) => super.copyWith((message) => updates(message as Disconnect)) as Disconnect;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Disconnect create() => Disconnect._();
  Disconnect createEmptyInstance() => create();
  static $pb.PbList<Disconnect> createRepeated() => $pb.PbList<Disconnect>();
  @$core.pragma('dart2js:noInline')
  static Disconnect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Disconnect>(create);
  static Disconnect? _defaultInstance;
}

class Scan extends $pb.GeneratedMessage {
  factory Scan() => create();
  Scan._() : super();
  factory Scan.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Scan.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Scan', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Scan clone() => Scan()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Scan copyWith(void Function(Scan) updates) => super.copyWith((message) => updates(message as Scan)) as Scan;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Scan create() => Scan._();
  Scan createEmptyInstance() => create();
  static $pb.PbList<Scan> createRepeated() => $pb.PbList<Scan>();
  @$core.pragma('dart2js:noInline')
  static Scan getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Scan>(create);
  static Scan? _defaultInstance;
}

class GetWiFiStatus extends $pb.GeneratedMessage {
  factory GetWiFiStatus() => create();
  GetWiFiStatus._() : super();
  factory GetWiFiStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetWiFiStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetWiFiStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetWiFiStatus clone() => GetWiFiStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetWiFiStatus copyWith(void Function(GetWiFiStatus) updates) => super.copyWith((message) => updates(message as GetWiFiStatus)) as GetWiFiStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWiFiStatus create() => GetWiFiStatus._();
  GetWiFiStatus createEmptyInstance() => create();
  static $pb.PbList<GetWiFiStatus> createRepeated() => $pb.PbList<GetWiFiStatus>();
  @$core.pragma('dart2js:noInline')
  static GetWiFiStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetWiFiStatus>(create);
  static GetWiFiStatus? _defaultInstance;
}

enum WiFiMessage_Message {
  connect, 
  disconnect, 
  scan, 
  wifiStatus, 
  notSet
}

class WiFiMessage extends $pb.GeneratedMessage {
  factory WiFiMessage({
    Connect? connect,
    Disconnect? disconnect,
    Scan? scan,
    GetWiFiStatus? wifiStatus,
  }) {
    final $result = create();
    if (connect != null) {
      $result.connect = connect;
    }
    if (disconnect != null) {
      $result.disconnect = disconnect;
    }
    if (scan != null) {
      $result.scan = scan;
    }
    if (wifiStatus != null) {
      $result.wifiStatus = wifiStatus;
    }
    return $result;
  }
  WiFiMessage._() : super();
  factory WiFiMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WiFiMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, WiFiMessage_Message> _WiFiMessage_MessageByTag = {
    1 : WiFiMessage_Message.connect,
    2 : WiFiMessage_Message.disconnect,
    3 : WiFiMessage_Message.scan,
    4 : WiFiMessage_Message.wifiStatus,
    0 : WiFiMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WiFiMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<Connect>(1, _omitFieldNames ? '' : 'connect', subBuilder: Connect.create)
    ..aOM<Disconnect>(2, _omitFieldNames ? '' : 'disconnect', subBuilder: Disconnect.create)
    ..aOM<Scan>(3, _omitFieldNames ? '' : 'scan', subBuilder: Scan.create)
    ..aOM<GetWiFiStatus>(4, _omitFieldNames ? '' : 'wifiStatus', subBuilder: GetWiFiStatus.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WiFiMessage clone() => WiFiMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WiFiMessage copyWith(void Function(WiFiMessage) updates) => super.copyWith((message) => updates(message as WiFiMessage)) as WiFiMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WiFiMessage create() => WiFiMessage._();
  WiFiMessage createEmptyInstance() => create();
  static $pb.PbList<WiFiMessage> createRepeated() => $pb.PbList<WiFiMessage>();
  @$core.pragma('dart2js:noInline')
  static WiFiMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WiFiMessage>(create);
  static WiFiMessage? _defaultInstance;

  WiFiMessage_Message whichMessage() => _WiFiMessage_MessageByTag[$_whichOneof(0)]!;
  void clearMessage() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Connect get connect => $_getN(0);
  @$pb.TagNumber(1)
  set connect(Connect v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasConnect() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnect() => clearField(1);
  @$pb.TagNumber(1)
  Connect ensureConnect() => $_ensure(0);

  @$pb.TagNumber(2)
  Disconnect get disconnect => $_getN(1);
  @$pb.TagNumber(2)
  set disconnect(Disconnect v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDisconnect() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisconnect() => clearField(2);
  @$pb.TagNumber(2)
  Disconnect ensureDisconnect() => $_ensure(1);

  @$pb.TagNumber(3)
  Scan get scan => $_getN(2);
  @$pb.TagNumber(3)
  set scan(Scan v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasScan() => $_has(2);
  @$pb.TagNumber(3)
  void clearScan() => clearField(3);
  @$pb.TagNumber(3)
  Scan ensureScan() => $_ensure(2);

  @$pb.TagNumber(4)
  GetWiFiStatus get wifiStatus => $_getN(3);
  @$pb.TagNumber(4)
  set wifiStatus(GetWiFiStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasWifiStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearWifiStatus() => clearField(4);
  @$pb.TagNumber(4)
  GetWiFiStatus ensureWifiStatus() => $_ensure(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
