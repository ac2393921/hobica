import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/mocks/mock_settings_repository.dart';

void main() {
  late MockSettingsRepository repository;

  setUp(() {
    repository = MockSettingsRepository();
  });

  group('MockSettingsRepository', () {
    group('getSettings', () {
      test('returns settings with default values initially', () async {
        final settings = await repository.getSettings();
        expect(settings.id, 1);
        expect(settings.themeMode, AppThemeMode.system);
        expect(settings.notificationsEnabled, isTrue);
        expect(settings.locale, 'ja');
      });
    });

    group('updateThemeMode', () {
      test('updates themeMode to light', () async {
        final settings = await repository.updateThemeMode(AppThemeMode.light);
        expect(settings.themeMode, AppThemeMode.light);
      });

      test('updates themeMode to dark', () async {
        final settings = await repository.updateThemeMode(AppThemeMode.dark);
        expect(settings.themeMode, AppThemeMode.dark);
      });

      test('persists change in subsequent getSettings', () async {
        await repository.updateThemeMode(AppThemeMode.dark);
        final settings = await repository.getSettings();
        expect(settings.themeMode, AppThemeMode.dark);
      });

      test('does not affect other fields', () async {
        await repository.updateNotificationEnabled(enabled: false);
        await repository.updateThemeMode(AppThemeMode.dark);

        final settings = await repository.getSettings();
        expect(settings.themeMode, AppThemeMode.dark);
        expect(settings.notificationsEnabled, isFalse);
      });
    });

    group('updateNotificationEnabled', () {
      test('updates notificationsEnabled to false', () async {
        final settings = await repository.updateNotificationEnabled(enabled: false);
        expect(settings.notificationsEnabled, isFalse);
      });

      test('can toggle back to true', () async {
        await repository.updateNotificationEnabled(enabled: false);
        final settings = await repository.updateNotificationEnabled(enabled: true);
        expect(settings.notificationsEnabled, isTrue);
      });

      test('persists change in subsequent getSettings', () async {
        await repository.updateNotificationEnabled(enabled: false);
        final settings = await repository.getSettings();
        expect(settings.notificationsEnabled, isFalse);
      });

      test('does not affect other fields', () async {
        await repository.updateThemeMode(AppThemeMode.dark);
        await repository.updateNotificationEnabled(enabled: false);

        final settings = await repository.getSettings();
        expect(settings.themeMode, AppThemeMode.dark);
        expect(settings.notificationsEnabled, isFalse);
      });
    });
  });
}
