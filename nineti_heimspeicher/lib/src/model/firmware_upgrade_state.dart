import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class FirmwareUpgradeState extends Equatable {
  final String? errorMessage;
  final double progress;
  final int? resultCode;
  final String status;

  FirmwareUpgradeState({
    required this.progress,
    required this.status,
    this.resultCode,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        progress,
        resultCode,
        status,
      ];

  FirmwareUpgradeState copyWith({
    ValueGetter<String?>? errorMessage,
    ValueGetter<double>? progress,
    ValueGetter<int?>? resultCode,
    ValueGetter<String>? status,
  }) {
    return FirmwareUpgradeState(
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      progress: progress != null ? progress() : this.progress,
      resultCode: resultCode != null ? resultCode() : this.resultCode,
      status: status != null ? status() : this.status,
    );
  }

  @override
  String toString() {
    return 'FirmwareUpgradeState(\n'
        '  errorMessage: $errorMessage,\n'
        '  progress: ${progress.toStringAsFixed(2)},\n'
        '  resultCode: $resultCode,\n'
        '  status: $status\n'
        ')';
  }
}
