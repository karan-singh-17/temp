//
//  Generated code. Do not modify.
//  source: cloud_provisioning_from_device.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'cloud_provisioning_from_device.pbenum.dart';

export 'cloud_provisioning_from_device.pbenum.dart';

enum CloudProvisioningUpdate_Update {
  provisioningStatus, 
  notSet
}

class CloudProvisioningUpdate extends $pb.GeneratedMessage {
  factory CloudProvisioningUpdate({
    ProvisioningStatus? provisioningStatus,
  }) {
    final $result = create();
    if (provisioningStatus != null) {
      $result.provisioningStatus = provisioningStatus;
    }
    return $result;
  }
  CloudProvisioningUpdate._() : super();
  factory CloudProvisioningUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CloudProvisioningUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, CloudProvisioningUpdate_Update> _CloudProvisioningUpdate_UpdateByTag = {
    1 : CloudProvisioningUpdate_Update.provisioningStatus,
    0 : CloudProvisioningUpdate_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CloudProvisioningUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'from_device'), createEmptyInstance: create)
    ..oo(0, [1])
    ..e<ProvisioningStatus>(1, _omitFieldNames ? '' : 'provisioningStatus', $pb.PbFieldType.OE, defaultOrMaker: ProvisioningStatus.PROVISIONING_STATUS_UNKNOWN, valueOf: ProvisioningStatus.valueOf, enumValues: ProvisioningStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CloudProvisioningUpdate clone() => CloudProvisioningUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CloudProvisioningUpdate copyWith(void Function(CloudProvisioningUpdate) updates) => super.copyWith((message) => updates(message as CloudProvisioningUpdate)) as CloudProvisioningUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudProvisioningUpdate create() => CloudProvisioningUpdate._();
  CloudProvisioningUpdate createEmptyInstance() => create();
  static $pb.PbList<CloudProvisioningUpdate> createRepeated() => $pb.PbList<CloudProvisioningUpdate>();
  @$core.pragma('dart2js:noInline')
  static CloudProvisioningUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudProvisioningUpdate>(create);
  static CloudProvisioningUpdate? _defaultInstance;

  CloudProvisioningUpdate_Update whichUpdate() => _CloudProvisioningUpdate_UpdateByTag[$_whichOneof(0)]!;
  void clearUpdate() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ProvisioningStatus get provisioningStatus => $_getN(0);
  @$pb.TagNumber(1)
  set provisioningStatus(ProvisioningStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProvisioningStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvisioningStatus() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
