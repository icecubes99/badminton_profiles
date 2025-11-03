import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_settings.dart';

// Abstract interface for user settings persistence
abstract class SettingsRepository {
  Future<void> init();
  Future<UserSettings> loadSettings();
  Future<void> saveSettings(UserSettings settings);
}

// Hive implementation of settings repository
class HiveSettingsRepository implements SettingsRepository {
  static const String _boxName = 'user_settings';
  static const String _settingsKey = 'settings';
  Box<UserSettings>? _box;

  @override
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<UserSettings>(_boxName);
    }
  }

  @override
  Future<UserSettings> loadSettings() async {
    await init();
    return _box!.get(_settingsKey, defaultValue: UserSettings.defaults) ?? UserSettings.defaults;
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    await init();
    await _box!.put(_settingsKey, settings);
  }
}
