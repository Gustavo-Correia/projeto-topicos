import 'package:assinaturas_ninja/features/settings/model/app_settings.dart';

abstract class SettingsStorage {
  Future<AppSettings> loadSettings();

  Future<void> saveSettings(AppSettings settings);
}
