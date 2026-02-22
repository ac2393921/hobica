import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';

void main() {
  final updatedAt = DateTime(2024, 1, 1);

  group('AppSettings', () {
    test('generates instance with required fields', () {
      final settings = AppSettings(id: 1, updatedAt: updatedAt);

      expect(settings.id, 1);
      expect(settings.updatedAt, updatedAt);
    });

    test('themeMode defaults to AppThemeMode.system', () {
      final settings = AppSettings(id: 1, updatedAt: updatedAt);

      expect(settings.themeMode, AppThemeMode.system);
    });

    test('notificationsEnabled defaults to true', () {
      final settings = AppSettings(id: 1, updatedAt: updatedAt);

      expect(settings.notificationsEnabled, isTrue);
    });

    test('locale defaults to ja', () {
      final settings = AppSettings(id: 1, updatedAt: updatedAt);

      expect(settings.locale, 'ja');
    });

    test('copyWith changes specified fields', () {
      final settings = AppSettings(id: 1, updatedAt: updatedAt);

      final updated = settings.copyWith(
        themeMode: AppThemeMode.dark,
        notificationsEnabled: false,
        locale: 'en',
      );

      expect(updated.themeMode, AppThemeMode.dark);
      expect(updated.notificationsEnabled, isFalse);
      expect(updated.locale, 'en');
      expect(updated.id, settings.id);
    });

    test('equality holds for identical instances', () {
      final a = AppSettings(id: 1, updatedAt: updatedAt);
      final b = AppSettings(id: 1, updatedAt: updatedAt);

      expect(a, equals(b));
    });

    test('JSON round-trip restores original values', () {
      final settings = AppSettings(
        id: 1,
        themeMode: AppThemeMode.light,
        notificationsEnabled: false,
        locale: 'en',
        updatedAt: updatedAt,
      );

      final restored = AppSettings.fromJson(settings.toJson());

      expect(restored, equals(settings));
    });
  });
}
