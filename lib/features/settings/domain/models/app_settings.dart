import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_theme_mode.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required int id,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(true) bool notificationsEnabled,
    @Default('ja') String locale,
    required DateTime updatedAt,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
