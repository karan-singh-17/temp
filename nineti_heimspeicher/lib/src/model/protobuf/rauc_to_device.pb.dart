//
//  Generated code. Do not modify.
//  source: rauc_to_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum DeviceAdministrationMessage_Message {
  installBundle, 
  getDeviceState, 
  getSlotStates, 
  getBundleInformation, 
  rebootDevice, 
  notSet
}

class DeviceAdministrationMessage extends $pb.GeneratedMessage {
  factory DeviceAdministrationMessage({
    InstallBundle? installBundle,
    GetDeviceState? getDeviceState,
    GetSlotStates? getSlotStates,
    GetBundleInformation? getBundleInformation,
    RebootDevice? rebootDevice,
  }) {
    final $result = create();
    if (installBundle != null) {
      $result.installBundle = installBundle;
    }
    if (getDeviceState != null) {
      $result.getDeviceState = getDeviceState;
    }
    if (getSlotStates != null) {
      $result.getSlotStates = getSlotStates;
    }
    if (getBundleInformation != null) {
      $result.getBundleInformation = getBundleInformation;
    }
    if (rebootDevice != null) {
      $result.rebootDevice = rebootDevice;
    }
    return $result;
  }
  DeviceAdministrationMessage._() : super();
  factory DeviceAdministrationMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceAdministrationMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, DeviceAdministrationMessage_Message> _DeviceAdministrationMessage_MessageByTag = {
    1 : DeviceAdministrationMessage_Message.installBundle,
    2 : DeviceAdministrationMessage_Message.getDeviceState,
    3 : DeviceAdministrationMessage_Message.getSlotStates,
    4 : DeviceAdministrationMessage_Message.getBundleInformation,
    5 : DeviceAdministrationMessage_Message.rebootDevice,
    0 : DeviceAdministrationMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceAdministrationMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<InstallBundle>(1, _omitFieldNames ? '' : 'installBundle', subBuilder: InstallBundle.create)
    ..aOM<GetDeviceState>(2, _omitFieldNames ? '' : 'getDeviceState', subBuilder: GetDeviceState.create)
    ..aOM<GetSlotStates>(3, _omitFieldNames ? '' : 'getSlotStates', subBuilder: GetSlotStates.create)
    ..aOM<GetBundleInformation>(4, _omitFieldNames ? '' : 'getBundleInformation', subBuilder: GetBundleInformation.create)
    ..aOM<RebootDevice>(5, _omitFieldNames ? '' : 'rebootDevice', subBuilder: RebootDevice.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceAdministrationMessage clone() => DeviceAdministrationMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceAdministrationMessage copyWith(void Function(DeviceAdministrationMessage) updates) => super.copyWith((message) => updates(message as DeviceAdministrationMessage)) as DeviceAdministrationMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceAdministrationMessage create() => DeviceAdministrationMessage._();
  DeviceAdministrationMessage createEmptyInstance() => create();
  static $pb.PbList<DeviceAdministrationMessage> createRepeated() => $pb.PbList<DeviceAdministrationMessage>();
  @$core.pragma('dart2js:noInline')
  static DeviceAdministrationMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceAdministrationMessage>(create);
  static DeviceAdministrationMessage? _defaultInstance;

  DeviceAdministrationMessage_Message whichMessage() => _DeviceAdministrationMessage_MessageByTag[$_whichOneof(0)]!;
  void clearMessage() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  InstallBundle get installBundle => $_getN(0);
  @$pb.TagNumber(1)
  set installBundle(InstallBundle v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInstallBundle() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallBundle() => clearField(1);
  @$pb.TagNumber(1)
  InstallBundle ensureInstallBundle() => $_ensure(0);

  @$pb.TagNumber(2)
  GetDeviceState get getDeviceState => $_getN(1);
  @$pb.TagNumber(2)
  set getDeviceState(GetDeviceState v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasGetDeviceState() => $_has(1);
  @$pb.TagNumber(2)
  void clearGetDeviceState() => clearField(2);
  @$pb.TagNumber(2)
  GetDeviceState ensureGetDeviceState() => $_ensure(1);

  @$pb.TagNumber(3)
  GetSlotStates get getSlotStates => $_getN(2);
  @$pb.TagNumber(3)
  set getSlotStates(GetSlotStates v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasGetSlotStates() => $_has(2);
  @$pb.TagNumber(3)
  void clearGetSlotStates() => clearField(3);
  @$pb.TagNumber(3)
  GetSlotStates ensureGetSlotStates() => $_ensure(2);

  @$pb.TagNumber(4)
  GetBundleInformation get getBundleInformation => $_getN(3);
  @$pb.TagNumber(4)
  set getBundleInformation(GetBundleInformation v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGetBundleInformation() => $_has(3);
  @$pb.TagNumber(4)
  void clearGetBundleInformation() => clearField(4);
  @$pb.TagNumber(4)
  GetBundleInformation ensureGetBundleInformation() => $_ensure(3);

  @$pb.TagNumber(5)
  RebootDevice get rebootDevice => $_getN(4);
  @$pb.TagNumber(5)
  set rebootDevice(RebootDevice v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRebootDevice() => $_has(4);
  @$pb.TagNumber(5)
  void clearRebootDevice() => clearField(5);
  @$pb.TagNumber(5)
  RebootDevice ensureRebootDevice() => $_ensure(4);
}

class InstallBundle extends $pb.GeneratedMessage {
  factory InstallBundle({
    $core.String? uri,
  }) {
    final $result = create();
    if (uri != null) {
      $result.uri = uri;
    }
    return $result;
  }
  InstallBundle._() : super();
  factory InstallBundle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InstallBundle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InstallBundle', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'uri')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InstallBundle clone() => InstallBundle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InstallBundle copyWith(void Function(InstallBundle) updates) => super.copyWith((message) => updates(message as InstallBundle)) as InstallBundle;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InstallBundle create() => InstallBundle._();
  InstallBundle createEmptyInstance() => create();
  static $pb.PbList<InstallBundle> createRepeated() => $pb.PbList<InstallBundle>();
  @$core.pragma('dart2js:noInline')
  static InstallBundle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InstallBundle>(create);
  static InstallBundle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uri => $_getSZ(0);
  @$pb.TagNumber(1)
  set uri($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUri() => $_has(0);
  @$pb.TagNumber(1)
  void clearUri() => clearField(1);
}

class GetSlotStates extends $pb.GeneratedMessage {
  factory GetSlotStates() => create();
  GetSlotStates._() : super();
  factory GetSlotStates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSlotStates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSlotStates', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSlotStates clone() => GetSlotStates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSlotStates copyWith(void Function(GetSlotStates) updates) => super.copyWith((message) => updates(message as GetSlotStates)) as GetSlotStates;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSlotStates create() => GetSlotStates._();
  GetSlotStates createEmptyInstance() => create();
  static $pb.PbList<GetSlotStates> createRepeated() => $pb.PbList<GetSlotStates>();
  @$core.pragma('dart2js:noInline')
  static GetSlotStates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSlotStates>(create);
  static GetSlotStates? _defaultInstance;
}

class GetDeviceState extends $pb.GeneratedMessage {
  factory GetDeviceState() => create();
  GetDeviceState._() : super();
  factory GetDeviceState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDeviceState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDeviceState', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDeviceState clone() => GetDeviceState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDeviceState copyWith(void Function(GetDeviceState) updates) => super.copyWith((message) => updates(message as GetDeviceState)) as GetDeviceState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeviceState create() => GetDeviceState._();
  GetDeviceState createEmptyInstance() => create();
  static $pb.PbList<GetDeviceState> createRepeated() => $pb.PbList<GetDeviceState>();
  @$core.pragma('dart2js:noInline')
  static GetDeviceState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDeviceState>(create);
  static GetDeviceState? _defaultInstance;
}

class GetBundleInformation extends $pb.GeneratedMessage {
  factory GetBundleInformation({
    $core.String? uri,
  }) {
    final $result = create();
    if (uri != null) {
      $result.uri = uri;
    }
    return $result;
  }
  GetBundleInformation._() : super();
  factory GetBundleInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetBundleInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetBundleInformation', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'uri')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetBundleInformation clone() => GetBundleInformation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetBundleInformation copyWith(void Function(GetBundleInformation) updates) => super.copyWith((message) => updates(message as GetBundleInformation)) as GetBundleInformation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBundleInformation create() => GetBundleInformation._();
  GetBundleInformation createEmptyInstance() => create();
  static $pb.PbList<GetBundleInformation> createRepeated() => $pb.PbList<GetBundleInformation>();
  @$core.pragma('dart2js:noInline')
  static GetBundleInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetBundleInformation>(create);
  static GetBundleInformation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uri => $_getSZ(0);
  @$pb.TagNumber(1)
  set uri($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUri() => $_has(0);
  @$pb.TagNumber(1)
  void clearUri() => clearField(1);
}

class RebootDevice extends $pb.GeneratedMessage {
  factory RebootDevice() => create();
  RebootDevice._() : super();
  factory RebootDevice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RebootDevice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RebootDevice', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RebootDevice clone() => RebootDevice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RebootDevice copyWith(void Function(RebootDevice) updates) => super.copyWith((message) => updates(message as RebootDevice)) as RebootDevice;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RebootDevice create() => RebootDevice._();
  RebootDevice createEmptyInstance() => create();
  static $pb.PbList<RebootDevice> createRepeated() => $pb.PbList<RebootDevice>();
  @$core.pragma('dart2js:noInline')
  static RebootDevice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RebootDevice>(create);
  static RebootDevice? _defaultInstance;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
