import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> getSettings();

  Future<AppSettings> updateThemeMode(AppThemeMode themeMode);

  Future<AppSettings> updateNotificationEnabled({required bool enabled});
}
