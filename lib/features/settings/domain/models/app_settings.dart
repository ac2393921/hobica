import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

// Flutter の ThemeMode に依存しない独自 enum（Clean Architecture 原則）
enum AppThemeMode { light, dark, system }

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required int id,
    required AppThemeMode themeMode,
    required bool notificationsEnabled,
    required String locale,
    required DateTime updatedAt,
  }) = _AppSettings;
}
