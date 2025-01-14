import 'dart:async';

/// {@template timer_strategy}
/// Parent class for all TimerStrategies
/// {@endtemplate}
abstract class TimerStrategy {
  /// {@macro timer_strategy}
  TimerStrategy();

  late final void Function() _onEvent;
  Timer? _timer;

  bool callbackSet = false;

  Duration _nextTimerDuration();
  TimerStrategy copyWith();

  // ignore: avoid_setters_without_getters
  set onEvent(void Function() callback) {
    if (callbackSet) {
      throw StateError('Callback has already been set');
    }

    _onEvent = callback;
    callbackSet = true;
  }

  void _checkCallbackIsSet() {
    if (callbackSet) {
      return;
    }

    throw StateError('Callback is not set');
  }

  /// Starts a [Timer]. When the [Timer] is done, execute the given callback
  ///
  /// When a previos [Timer] is started and is not done yet, cancel the previos
  /// [Timer] and start a new one
  void start() {
    _checkCallbackIsSet();
    cancel();
    _timer = Timer(_nextTimerDuration(), _onEvent);
  }

  /// Cancel the current [Timer], if one is started
  void cancel() {
    _timer?.cancel();
  }
}

/// {@template constant_timer_strategy}
/// A [TimerStrategy] that uses a constant [Duration] for the [Timer]
/// {@endtemplate}
class ConstantTimerStrategy extends TimerStrategy {
  /// {macro constant_timer_strategy}
  ConstantTimerStrategy({
    required this.timeout,
  });

  final Duration timeout;

  @override
  Duration _nextTimerDuration() {
    return timeout;
  }

  @override
  ConstantTimerStrategy copyWith({Duration? timeout}) {
    return ConstantTimerStrategy(
      timeout: timeout ?? this.timeout,
    );
  }
}
