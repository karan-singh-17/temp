part of 'device_administration.dart';

class SlotStates extends DeviceAdministrationUpdate {
  final List<FirmwareSlotInformation> slots;

  SlotStates({
    required this.slots,
  });

  @override
  List<Object?> get props => [
        slots,
      ];
}

extension SlotStatesToModel on from_pb.SlotStates {
  SlotStates toModel() {
    return SlotStates(
      slots: slotStates.map((e) => e.toModel()).toList(),
    );
  }
}

enum SlotStatus {
  booted,
  inactive,
  active,
}

extension SlotStatusToModel on from_pb.SlotStatus {
  SlotStatus toModel() {
    switch (this) {
      case from_pb.SlotStatus.booted:
        return SlotStatus.booted;
      case from_pb.SlotStatus.inactive:
        return SlotStatus.inactive;
      case from_pb.SlotStatus.active:
        return SlotStatus.active;
      default:
        throw Exception('Invalid SlotStatus');
    }
  }
}

class FirmwareSlotInformation extends Equatable {
  final String hash;
  final String version;
  final SlotStatus status;

  FirmwareSlotInformation({
    required this.hash,
    required this.version,
    required this.status,
  });

  @override
  List<Object?> get props => [
        hash,
        version,
        status,
      ];

  @override
  String toString() {
    return 'SlotState{ version: $version, status: $status, hash: $hash }';
  }
}

extension SlotStateToModel on from_pb.SlotState {
  FirmwareSlotInformation toModel() {
    return FirmwareSlotInformation(
      hash: bundleHash,
      version: firmwareVersion,
      status: status.toModel(),
    );
  }
}
