part of 'splash_screen_cubit.dart';

enum InitializationState {
  uninitialized,
  inProgress,
  successful,
  failed,
}

@immutable
class SplashScreenState extends Equatable {
  const SplashScreenState({
    required this.state,
    this.error,
  });

  const SplashScreenState.uninitialized()
      : state = InitializationState.uninitialized,
        error = null;

  final InitializationState state;
  final Object? error;

  SplashScreenState copyWith({
    ValueGetter<InitializationState>? state,
    ValueGetter<Object?>? error,
  }) {
    return SplashScreenState(
      state: state != null ? state() : this.state,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [
        state,
        error,
      ];
}
