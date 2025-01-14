import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:rxdart/rxdart.dart';

part 'rauc_update_event.dart';
part 'rauc_update_state.dart';

class RaucUpgradeBloc extends Bloc<RaucUpgradeEvent, RaucUpgradeState> {
  RaucUpgradeBloc({
    required FirmwareUpgrade Function(String) createRaucUpdate,
    required ValueStream<DeviceState> operationState,
  })  : _createRaucUpdate = createRaucUpdate,
        super(
          RaucUpgradeState(
            updateTriggered: false,
            state: null,
            deviceState: operationState.value,
            updateDone: false,
          ),
        ) {
    on<StartRaucUpdateEvent>(_onStartRaucUpdate);
    on<HandleUpdateStateStreamEvent>(_onHandleUpdateStateStream);
    on<HandleDeviceStateStreamEvent>(_onHandleDeviceStateStream);

    add(HandleDeviceStateStreamEvent(operationStateStream: operationState));
  }

  @override
  void onTransition(Transition<RaucUpgradeEvent, RaucUpgradeState> transition) {
    Logger().i(transition);
    super.onTransition(transition);
  }

  final FirmwareUpgrade Function(String uri) _createRaucUpdate;
  late final FirmwareUpgrade _firmwareUpgrade;

  FutureOr<void> _onStartRaucUpdate(
    StartRaucUpdateEvent event,
    Emitter<RaucUpgradeState> emit,
  ) async {
    _firmwareUpgrade = _createRaucUpdate(event.uri);
    add(HandleUpdateStateStreamEvent(stateStream: _firmwareUpgrade.state));

    emit(
      state.copyWith(
        updateTriggered: () => true,
      ),
    );
    await _firmwareUpgrade.startFirmwareUpdate();
  }

  FutureOr<void> _onHandleUpdateStateStream(
    HandleUpdateStateStreamEvent event,
    Emitter<RaucUpgradeState> emit,
  ) async {
    await emit.forEach(
      event.stateStream,
      onData: (firmwareUpgradeState) => state.copyWith(
        state: () => firmwareUpgradeState,
        updateDone: firmwareUpgradeState.resultCode == null ? null : () => true,
      ),
    );
  }

  FutureOr<void> _onHandleDeviceStateStream(
    HandleDeviceStateStreamEvent event,
    Emitter<RaucUpgradeState> emit,
  ) async {
    await emit.forEach(
      event.operationStateStream,
      onData: (deviceState) => state.copyWith(
        deviceState: () => deviceState,
      ),
    );
  }
}
