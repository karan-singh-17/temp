//
//  Generated code. Do not modify.
//  source: cloud_provisioning_to_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum CloudProvisioningMessage_Message {
  provisionDevice, 
  notSet
}

class CloudProvisioningMessage extends $pb.GeneratedMessage {
  factory CloudProvisioningMessage({
    ProvisionDevice? provisionDevice,
  }) {
    final $result = create();
    if (provisionDevice != null) {
      $result.provisionDevice = provisionDevice;
    }
    return $result;
  }
  CloudProvisioningMessage._() : super();
  factory CloudProvisioningMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CloudProvisioningMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, CloudProvisioningMessage_Message> _CloudProvisioningMessage_MessageByTag = {
    1 : CloudProvisioningMessage_Message.provisionDevice,
    0 : CloudProvisioningMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudProvisioningMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<ProvisionDevice>(1, _omitFieldNames ? '' : 'provisionDevice', subBuilder: ProvisionDevice.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CloudProvisioningMessage clone() => CloudProvisioningMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CloudProvisioningMessage copyWith(void Function(CloudProvisioningMessage) updates) => super.copyWith((message) => updates(message as CloudProvisioningMessage)) as CloudProvisioningMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudProvisioningMessage create() => CloudProvisioningMessage._();
  CloudProvisioningMessage createEmptyInstance() => create();
  static $pb.PbList<CloudProvisioningMessage> createRepeated() => $pb.PbList<CloudProvisioningMessage>();
  @$core.pragma('dart2js:noInline')
  static CloudProvisioningMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudProvisioningMessage>(create);
  static CloudProvisioningMessage? _defaultInstance;

  CloudProvisioningMessage_Message whichMessage() => _CloudProvisioningMessage_MessageByTag[$_whichOneof(0)]!;
  void clearMessage() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ProvisionDevice get provisionDevice => $_getN(0);
  @$pb.TagNumber(1)
  set provisionDevice(ProvisionDevice v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProvisionDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvisionDevice() => clearField(1);
  @$pb.TagNumber(1)
  ProvisionDevice ensureProvisionDevice() => $_ensure(0);
}

class ProvisionDevice extends $pb.GeneratedMessage {
  factory ProvisionDevice({
    $core.List<$core.int>? provisioningData,
  }) {
    final $result = create();
    if (provisioningData != null) {
      $result.provisioningData = provisioningData;
    }
    return $result;
  }
  ProvisionDevice._() : super();
  factory ProvisionDevice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProvisionDevice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProvisionDevice', package: const $pb.PackageName(_omitMessageNames ? '' : 'to_device'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'provisioningData', $pb.PbFieldType.QY)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProvisionDevice clone() => ProvisionDevice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProvisionDevice copyWith(void Function(ProvisionDevice) updates) => super.copyWith((message) => updates(message as ProvisionDevice)) as ProvisionDevice;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProvisionDevice create() => ProvisionDevice._();
  ProvisionDevice createEmptyInstance() => create();
  static $pb.PbList<ProvisionDevice> createRepeated() => $pb.PbList<ProvisionDevice>();
  @$core.pragma('dart2js:noInline')
  static ProvisionDevice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProvisionDevice>(create);
  static ProvisionDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get provisioningData => $_getN(0);
  @$pb.TagNumber(1)
  set provisioningData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProvisioningData() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvisioningData() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
