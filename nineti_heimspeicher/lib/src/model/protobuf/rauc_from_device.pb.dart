//
//  Generated code. Do not modify.
//  source: rauc_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'rauc_from_device.pbenum.dart';

export 'rauc_from_device.pbenum.dart';

class ProgressUpdate extends $pb.GeneratedMessage {
  factory ProgressUpdate({
    $core.double? progress,
    $core.String? status,
    $core.int? resultCode,
  }) {
    final $result = create();
    if (progress != null) {
      $result.progress = progress;
    }
    if (status != null) {
      $result.status = status;
    }
    if (resultCode != null) {
      $result.resultCode = resultCode;
    }
    return $result;
  }
  ProgressUpdate._() : super();
  factory ProgressUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProgressUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProgressUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'progress', $pb.PbFieldType.QF)
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'resultCode', $pb.PbFieldType.O3)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProgressUpdate clone() => ProgressUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProgressUpdate copyWith(void Function(ProgressUpdate) updates) => super.copyWith((message) => updates(message as ProgressUpdate)) as ProgressUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProgressUpdate create() => ProgressUpdate._();
  ProgressUpdate createEmptyInstance() => create();
  static $pb.PbList<ProgressUpdate> createRepeated() => $pb.PbList<ProgressUpdate>();
  @$core.pragma('dart2js:noInline')
  static ProgressUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProgressUpdate>(create);
  static ProgressUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resultCode => $_getIZ(2);
  @$pb.TagNumber(3)
  set resultCode($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResultCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearResultCode() => clearField(3);
}

class SlotStates extends $pb.GeneratedMessage {
  factory SlotStates({
    $core.Iterable<SlotState>? slotStates,
  }) {
    final $result = create();
    if (slotStates != null) {
      $result.slotStates.addAll(slotStates);
    }
    return $result;
  }
  SlotStates._() : super();
  factory SlotStates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlotStates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SlotStates', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..pc<SlotState>(1, _omitFieldNames ? '' : 'slotStates', $pb.PbFieldType.PM, subBuilder: SlotState.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlotStates clone() => SlotStates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlotStates copyWith(void Function(SlotStates) updates) => super.copyWith((message) => updates(message as SlotStates)) as SlotStates;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SlotStates create() => SlotStates._();
  SlotStates createEmptyInstance() => create();
  static $pb.PbList<SlotStates> createRepeated() => $pb.PbList<SlotStates>();
  @$core.pragma('dart2js:noInline')
  static SlotStates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlotStates>(create);
  static SlotStates? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SlotState> get slotStates => $_getList(0);
}

class SlotState extends $pb.GeneratedMessage {
  factory SlotState({
    SlotStatus? status,
    $core.String? bundleHash,
    $core.String? firmwareVersion,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (bundleHash != null) {
      $result.bundleHash = bundleHash;
    }
    if (firmwareVersion != null) {
      $result.firmwareVersion = firmwareVersion;
    }
    return $result;
  }
  SlotState._() : super();
  factory SlotState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlotState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SlotState', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..e<SlotStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.QE, defaultOrMaker: SlotStatus.booted, valueOf: SlotStatus.valueOf, enumValues: SlotStatus.values)
    ..aQS(2, _omitFieldNames ? '' : 'bundleHash')
    ..aQS(3, _omitFieldNames ? '' : 'firmwareVersion')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlotState clone() => SlotState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlotState copyWith(void Function(SlotState) updates) => super.copyWith((message) => updates(message as SlotState)) as SlotState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SlotState create() => SlotState._();
  SlotState createEmptyInstance() => create();
  static $pb.PbList<SlotState> createRepeated() => $pb.PbList<SlotState>();
  @$core.pragma('dart2js:noInline')
  static SlotState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlotState>(create);
  static SlotState? _defaultInstance;

  @$pb.TagNumber(1)
  SlotStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(SlotStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get bundleHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set bundleHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBundleHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearBundleHash() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get firmwareVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set firmwareVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFirmwareVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirmwareVersion() => clearField(3);
}

class BundleInformation extends $pb.GeneratedMessage {
  factory BundleInformation({
    $core.String? uri,
    $core.String? bundleHash,
    $core.String? firmwareVersion,
  }) {
    final $result = create();
    if (uri != null) {
      $result.uri = uri;
    }
    if (bundleHash != null) {
      $result.bundleHash = bundleHash;
    }
    if (firmwareVersion != null) {
      $result.firmwareVersion = firmwareVersion;
    }
    return $result;
  }
  BundleInformation._() : super();
  factory BundleInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BundleInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BundleInformation', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'uri')
    ..aQS(2, _omitFieldNames ? '' : 'bundleHash')
    ..aQS(3, _omitFieldNames ? '' : 'firmwareVersion')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BundleInformation clone() => BundleInformation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BundleInformation copyWith(void Function(BundleInformation) updates) => super.copyWith((message) => updates(message as BundleInformation)) as BundleInformation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BundleInformation create() => BundleInformation._();
  BundleInformation createEmptyInstance() => create();
  static $pb.PbList<BundleInformation> createRepeated() => $pb.PbList<BundleInformation>();
  @$core.pragma('dart2js:noInline')
  static BundleInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BundleInformation>(create);
  static BundleInformation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uri => $_getSZ(0);
  @$pb.TagNumber(1)
  set uri($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUri() => $_has(0);
  @$pb.TagNumber(1)
  void clearUri() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get bundleHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set bundleHash($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBundleHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearBundleHash() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get firmwareVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set firmwareVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFirmwareVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirmwareVersion() => clearField(3);
}

class LastError extends $pb.GeneratedMessage {
  factory LastError({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  LastError._() : super();
  factory LastError.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LastError.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LastError', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'message')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LastError clone() => LastError()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LastError copyWith(void Function(LastError) updates) => super.copyWith((message) => updates(message as LastError)) as LastError;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LastError create() => LastError._();
  LastError createEmptyInstance() => create();
  static $pb.PbList<LastError> createRepeated() => $pb.PbList<LastError>();
  @$core.pragma('dart2js:noInline')
  static LastError getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LastError>(create);
  static LastError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

enum DeviceAdministrationUpdate_Update {
  progress, 
  deviceState, 
  slotStates, 
  bundleInformation, 
  error, 
  notSet
}

class DeviceAdministrationUpdate extends $pb.GeneratedMessage {
  factory DeviceAdministrationUpdate({
    ProgressUpdate? progress,
    DeviceState? deviceState,
    SlotStates? slotStates,
    BundleInformation? bundleInformation,
    LastError? error,
  }) {
    final $result = create();
    if (progress != null) {
      $result.progress = progress;
    }
    if (deviceState != null) {
      $result.deviceState = deviceState;
    }
    if (slotStates != null) {
      $result.slotStates = slotStates;
    }
    if (bundleInformation != null) {
      $result.bundleInformation = bundleInformation;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  DeviceAdministrationUpdate._() : super();
  factory DeviceAdministrationUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceAdministrationUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, DeviceAdministrationUpdate_Update> _DeviceAdministrationUpdate_UpdateByTag = {
    1 : DeviceAdministrationUpdate_Update.progress,
    2 : DeviceAdministrationUpdate_Update.deviceState,
    3 : DeviceAdministrationUpdate_Update.slotStates,
    4 : DeviceAdministrationUpdate_Update.bundleInformation,
    5 : DeviceAdministrationUpdate_Update.error,
    0 : DeviceAdministrationUpdate_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceAdministrationUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<ProgressUpdate>(1, _omitFieldNames ? '' : 'progress', subBuilder: ProgressUpdate.create)
    ..e<DeviceState>(2, _omitFieldNames ? '' : 'deviceState', $pb.PbFieldType.OE, defaultOrMaker: DeviceState.IDLE, valueOf: DeviceState.valueOf, enumValues: DeviceState.values)
    ..aOM<SlotStates>(3, _omitFieldNames ? '' : 'slotStates', subBuilder: SlotStates.create)
    ..aOM<BundleInformation>(4, _omitFieldNames ? '' : 'bundleInformation', subBuilder: BundleInformation.create)
    ..aOM<LastError>(5, _omitFieldNames ? '' : 'error', subBuilder: LastError.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceAdministrationUpdate clone() => DeviceAdministrationUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceAdministrationUpdate copyWith(void Function(DeviceAdministrationUpdate) updates) => super.copyWith((message) => updates(message as DeviceAdministrationUpdate)) as DeviceAdministrationUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceAdministrationUpdate create() => DeviceAdministrationUpdate._();
  DeviceAdministrationUpdate createEmptyInstance() => create();
  static $pb.PbList<DeviceAdministrationUpdate> createRepeated() => $pb.PbList<DeviceAdministrationUpdate>();
  @$core.pragma('dart2js:noInline')
  static DeviceAdministrationUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceAdministrationUpdate>(create);
  static DeviceAdministrationUpdate? _defaultInstance;

  DeviceAdministrationUpdate_Update whichUpdate() => _DeviceAdministrationUpdate_UpdateByTag[$_whichOneof(0)]!;
  void clearUpdate() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ProgressUpdate get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(ProgressUpdate v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => clearField(1);
  @$pb.TagNumber(1)
  ProgressUpdate ensureProgress() => $_ensure(0);

  @$pb.TagNumber(2)
  DeviceState get deviceState => $_getN(1);
  @$pb.TagNumber(2)
  set deviceState(DeviceState v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceState() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceState() => clearField(2);

  @$pb.TagNumber(3)
  SlotStates get slotStates => $_getN(2);
  @$pb.TagNumber(3)
  set slotStates(SlotStates v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSlotStates() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlotStates() => clearField(3);
  @$pb.TagNumber(3)
  SlotStates ensureSlotStates() => $_ensure(2);

  @$pb.TagNumber(4)
  BundleInformation get bundleInformation => $_getN(3);
  @$pb.TagNumber(4)
  set bundleInformation(BundleInformation v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasBundleInformation() => $_has(3);
  @$pb.TagNumber(4)
  void clearBundleInformation() => clearField(4);
  @$pb.TagNumber(4)
  BundleInformation ensureBundleInformation() => $_ensure(3);

  @$pb.TagNumber(5)
  LastError get error => $_getN(4);
  @$pb.TagNumber(5)
  set error(LastError v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(5)
  void clearError() => clearField(5);
  @$pb.TagNumber(5)
  LastError ensureError() => $_ensure(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
