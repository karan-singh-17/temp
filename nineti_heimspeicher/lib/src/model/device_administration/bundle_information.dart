part of 'device_administration.dart';

class BundleInformation extends DeviceAdministrationUpdate {
  final String uri;
  final String hash;
  final String version;

  BundleInformation({
    required this.uri,
    required this.hash,
    required this.version,
  });

  @override
  List<Object?> get props => [hash, version, version];
}

extension BundleInformationToModel on from_pb.BundleInformation {
  BundleInformation toModel() {
    return BundleInformation(
      uri: uri,
      hash: bundleHash,
      version: firmwareVersion,
    );
  }
}
