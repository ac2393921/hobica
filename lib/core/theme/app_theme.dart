import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'color_scheme.dart';
import 'typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppColorSchemes.light());
  static ThemeData get dark => _build(AppColorSchemes.dark());

  static ThemeData _build(ColorScheme colorScheme) => ThemeData(
        colorScheme: colorScheme,
        typography: AppTypography.geist,
        radius: 0.5,
      );
}
