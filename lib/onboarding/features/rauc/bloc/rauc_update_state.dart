part of 'rauc_update_bloc.dart';

class RaucUpgradeState extends Equatable {
  const RaucUpgradeState({
    required this.updateTriggered,
    required this.updateDone,
    required this.state,
    required this.deviceState,
  });

  final bool updateTriggered;
  final bool updateDone;
  final FirmwareUpgradeState? state;
  final DeviceState deviceState;

  @override
  List<Object?> get props => [
        updateTriggered,
        state,
        deviceState,
      ];

  RaucUpgradeState copyWith({
    ValueGetter<bool>? updateTriggered,
    ValueGetter<FirmwareUpgradeState?>? state,
    ValueGetter<DeviceState>? deviceState,
    ValueGetter<bool>? updateDone,
  }) {
    return RaucUpgradeState(
      updateTriggered: updateTriggered == null
          ? this.updateTriggered
          : updateTriggered.call(),
      state: state == null ? this.state : state.call(),
      deviceState: deviceState == null ? this.deviceState : deviceState.call(),
      updateDone: updateDone == null ? this.updateDone : updateDone.call(),
    );
  }

  @override
  String toString() {
    return 'RaucUpgradeState(\n'
        '  updateTriggered: $updateTriggered,\n'
        '  state: $state,\n'
        '  deviceState: $deviceState\n'
        ')';
  }
}
