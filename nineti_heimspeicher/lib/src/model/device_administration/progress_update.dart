part of 'device_administration.dart';

class ProgressUpdate extends DeviceAdministrationUpdate {
  final double progress;
  final String status;
  final int? resultCode;

  ProgressUpdate({
    required this.progress,
    required this.status,
    this.resultCode,
  });

  @override
  List<Object?> get props => [
        progress,
        status,
        resultCode,
      ];

  ProgressUpdate copyWith({
    ValueGetter<double>? progress,
    ValueGetter<String>? status,
    ValueGetter<int?>? resultCode,
  }) {
    return ProgressUpdate(
      progress: progress != null ? progress() : this.progress,
      status: status != null ? status() : this.status,
      resultCode: resultCode != null ? resultCode() : this.resultCode,
    );
  }
}

extension ProgressUpdateToModel on from_pb.ProgressUpdate {
  ProgressUpdate toModel() {
    return ProgressUpdate(
      progress: progress,
      status: status,
      resultCode: resultCode,
    );
  }
}
