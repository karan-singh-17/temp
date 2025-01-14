import 'package:moe/onboarding/features/splash_screen/initializable_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit({
    required this.initializables,
  }) : super(const SplashScreenState.uninitialized());

  final Initializables initializables;

  Future<void> _init() async {
    for (final initializable in initializables) {
      await initializable.init();
    }
  }

  Future<void> initialize() async {
    emit(const SplashScreenState(state: InitializationState.inProgress));

    try {
      await Future.wait([
        _init(),
        Future.delayed(const Duration(seconds: 2)),
      ]);
    } catch (e) {
      emit(const SplashScreenState(state: InitializationState.failed));
      return;
    }

    emit(const SplashScreenState(state: InitializationState.successful));
  }
}
