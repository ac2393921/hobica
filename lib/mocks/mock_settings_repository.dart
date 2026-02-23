import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/domain/repositories/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  AppSettings _settings = AppSettings(id: 1, updatedAt: DateTime.now());

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<AppSettings> updateThemeMode(AppThemeMode themeMode) async {
    _settings = _settings.copyWith(
      themeMode: themeMode,
      updatedAt: DateTime.now(),
    );
    return _settings;
  }

  @override
  Future<AppSettings> updateNotificationEnabled({required bool enabled}) async {
    _settings = _settings.copyWith(
      notificationsEnabled: enabled,
      updatedAt: DateTime.now(),
    );
    return _settings;
  }
}
