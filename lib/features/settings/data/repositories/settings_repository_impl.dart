import 'package:drift/drift.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _settingsId = 1;

  @override
  Future<AppSettings> getSettings() async {
    await _db.into(_db.appSettingsTable).insert(
          AppSettingsTableCompanion(
            id: const Value(_settingsId),
            themeMode: const Value('system'),
            notificationsEnabled: const Value(true),
            locale: const Value('ja'),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    final row = await (
      _db.select(_db.appSettingsTable)
        ..where((t) => t.id.equals(_settingsId))
    ).getSingle();
    return _rowToSettings(row);
  }

  @override
  Future<AppSettings> updateThemeMode(AppThemeMode themeMode) async {
    // デフォルト行が存在しない場合に備え、先に初期化する
    await getSettings();
    await (
      _db.update(_db.appSettingsTable)
        ..where((t) => t.id.equals(_settingsId))
    ).write(
      AppSettingsTableCompanion(
        themeMode: Value(themeMode.name),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return getSettings();
  }

  @override
  Future<AppSettings> updateNotificationEnabled({required bool enabled}) async {
    // デフォルト行が存在しない場合に備え、先に初期化する
    await getSettings();
    await (
      _db.update(_db.appSettingsTable)
        ..where((t) => t.id.equals(_settingsId))
    ).write(
      AppSettingsTableCompanion(
        notificationsEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return getSettings();
  }

  AppSettings _rowToSettings(AppSettingsRow row) {
    return AppSettings(
      id: row.id,
      themeMode: AppThemeMode.values.byName(row.themeMode),
      notificationsEnabled: row.notificationsEnabled,
      locale: row.locale,
      updatedAt: row.updatedAt,
    );
  }
}
