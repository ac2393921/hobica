import 'package:json_annotation/json_annotation.dart';

enum AppThemeMode {
  @JsonValue('light')
  light,

  @JsonValue('dark')
  dark,

  @JsonValue('system')
  system,
}
