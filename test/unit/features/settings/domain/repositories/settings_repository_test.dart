import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/domain/repositories/settings_repository.dart';

class _FakeSettingsRepository implements SettingsRepository {
  AppSettings _settings = AppSettings(
    id: 1,
    themeMode: AppThemeMode.system,
    notificationsEnabled: true,
    locale: 'ja',
    updatedAt: DateTime(2026, 2, 22),
  );

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<AppSettings> updateThemeMode(AppThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    return _settings;
  }

  @override
  Future<AppSettings> updateNotificationEnabled({required bool enabled}) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    return _settings;
  }
}

void main() {
  group('SettingsRepository インターフェースコントラクト', () {
    late SettingsRepository repository;

    setUp(() => repository = _FakeSettingsRepository());

    test('getSettings は AppSettings を返す', () async {
      final result = await repository.getSettings();
      expect(result, isA<AppSettings>());
    });

    test('updateThemeMode は更新後の AppSettings を返す', () async {
      final result = await repository.updateThemeMode(AppThemeMode.dark);
      expect(result, isA<AppSettings>());
      expect(result.themeMode, AppThemeMode.dark);
    });

    test('updateNotificationEnabled は更新後の AppSettings を返す', () async {
      final result = await repository.updateNotificationEnabled(enabled: false);
      expect(result, isA<AppSettings>());
      expect(result.notificationsEnabled, false);
    });
  });
}
