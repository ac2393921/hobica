import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late SettingsRepositoryImpl repo;

  setUp(() {
    db = _createInMemoryDb();
    repo = SettingsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SettingsRepositoryImpl', () {
    group('getSettings', () {
      test('creates default settings on first call', () async {
        final settings = await repo.getSettings();

        expect(settings.id, 1);
        expect(settings.themeMode, AppThemeMode.system);
        expect(settings.notificationsEnabled, isTrue);
        expect(settings.locale, 'ja');
      });

      test('returns same settings on subsequent calls', () async {
        final first = await repo.getSettings();
        final second = await repo.getSettings();

        expect(second.themeMode, first.themeMode);
        expect(second.notificationsEnabled, first.notificationsEnabled);
      });
    });

    group('updateThemeMode', () {
      test('updates theme mode to dark', () async {
        final settings = await repo.updateThemeMode(AppThemeMode.dark);

        expect(settings.themeMode, AppThemeMode.dark);
      });

      test('updates theme mode to light', () async {
        await repo.updateThemeMode(AppThemeMode.dark);
        final settings = await repo.updateThemeMode(AppThemeMode.light);

        expect(settings.themeMode, AppThemeMode.light);
      });
    });

    group('updateNotificationEnabled', () {
      test('disables notifications', () async {
        final settings =
            await repo.updateNotificationEnabled(enabled: false);

        expect(settings.notificationsEnabled, isFalse);
      });

      test('re-enables notifications', () async {
        await repo.updateNotificationEnabled(enabled: false);
        final settings =
            await repo.updateNotificationEnabled(enabled: true);

        expect(settings.notificationsEnabled, isTrue);
      });
    });
  });
}
