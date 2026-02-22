import 'package:hobica/features/settings/domain/models/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<AppSettings> updateThemeMode(AppThemeMode themeMode);
  Future<AppSettings> updateNotificationsEnabled({required bool enabled});
}
