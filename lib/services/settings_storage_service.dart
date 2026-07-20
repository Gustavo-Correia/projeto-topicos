import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/app_settings.dart';
import 'settings_storage.dart';

class SettingsStorageService implements SettingsStorage {
  static const String _settingsKey = 'app_settings';
  static const String _boxName = 'settings_box';

  @override
  Future<AppSettings> loadSettings() async {
    final box = Hive.box<String>(_boxName);
    final raw = box.get(_settingsKey);

    if (raw == null || raw.isEmpty) {
      return const AppSettings();
    }

    return AppSettings.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box<String>(_boxName);
    await box.put(_settingsKey, jsonEncode(settings.toMap()));
  }
}
