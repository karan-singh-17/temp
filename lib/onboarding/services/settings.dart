import 'package:moe/onboarding/model/initializable.dart';
import 'package:moe/onboarding/model/setting.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

const bool cleanSettings = bool.fromEnvironment('NINETI_CLEAN_SETTINGS');

class SettingsService implements Initializable {
  static const String _boxName = 'settingsBox';

  final BehaviorSubject<Box<dynamic>?> _settingsBoxStream =
      BehaviorSubject.seeded(null);
  Box<dynamic>? get _settingsBox => _settingsBoxStream.value;

  @override
  Future<void> init({HiveInterface? hive}) async {
    _settingsBoxStream.add(await (hive ?? Hive).openBox<dynamic>(_boxName));

    if (cleanSettings) {
      await _settingsBox?.clear();
    }

    // flush event queue for _settingsBoxStream subscribers
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> close() async {
    await _settingsBox?.close();
  }

  Future<void> setSetting<T>(Setting<T> setting, T value) async {
    if (_settingsBox == null) {
      throw StateError('SettingsService not initialized');
    }

    await _settingsBox?.put(setting.key, value);
  }

  /// Returns the current value of the settings.
  /// If the service is not initialized, the default value of the setting is returned.
  /// If the setting is not in the box, the default value of the setting is returned.
  T getSetting<T>(Setting setting) {
    return _settingsBox?.get(setting.key) ?? setting.defaultValue;
  }

  /// Returns a ValueStream of the setting.
  /// The stream will start with the current value of the setting.
  /// If the service is not initialized, the stream will start with the default value of the setting
  /// and will emit the set value after the service is initialized.
  ValueStream<T> watchSetting<T>(Setting<T> setting) {
    T eventToValue(BoxEvent event) {
      if (event.deleted) {
        return setting.defaultValue;
      }

      return event.value as T;
    }

    if (_settingsBox != null) {
      return _settingsBox!
          .watch(key: setting.key)
          .map(eventToValue)
          .publishValueSeeded(getSetting(setting))
        ..connect();
    }

    Stream<T> boxToStream(Box? box) {
      if (box == null) {
        return Stream<T>.empty();
      }

      return box.watch(key: setting.key).map(eventToValue).startWith(getSetting(
          setting)); // when box is initialized, emit the current value
    }

    return _settingsBoxStream
        .switchMap(boxToStream)
        .publishValueSeeded(setting.defaultValue)
      ..connect();
  }
}

class SettingsServiceProvider extends SingleChildStatelessWidget {
  const SettingsServiceProvider({
    this.child,
    super.key,
  });

  static const String boxName = 'pen_and_paper_settings_storage';

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Provider(
      create: (_) => SettingsService(),
      child: child,
    );
  }
}
