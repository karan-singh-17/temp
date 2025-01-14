part of 'rauc_update_bloc.dart';

sealed class RaucUpgradeEvent extends Equatable {
  const RaucUpgradeEvent();

  @override
  List<Object> get props => [];
}

class StartRaucUpdateEvent extends RaucUpgradeEvent {
  final String uri;

  const StartRaucUpdateEvent({required this.uri});

  @override
  List<Object> get props => [
        uri,
      ];
}

class HandleUpdateStateStreamEvent extends RaucUpgradeEvent {
  final Stream<FirmwareUpgradeState> stateStream;

  const HandleUpdateStateStreamEvent({required this.stateStream});

  @override
  List<Object> get props => [
        stateStream,
      ];
}

class HandleDeviceStateStreamEvent extends RaucUpgradeEvent {
  final ValueStream<DeviceState> operationStateStream;

  const HandleDeviceStateStreamEvent({required this.operationStateStream});

  @override
  List<Object> get props => [
        operationStateStream,
      ];
}
