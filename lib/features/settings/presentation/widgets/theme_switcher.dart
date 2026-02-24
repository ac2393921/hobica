import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// テーマ（ダーク/ライト）切り替えウィジェット。
///
/// Presentationalコンポーネント。状態管理を持たず、
/// [themeMode] と [onChanged] を受け取って表示する。
class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    required this.themeMode,
    required this.onChanged,
    super.key,
  });

  final AppThemeMode themeMode;
  final ValueChanged<AppThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == AppThemeMode.dark;

    return Switch(
      value: isDark,
      leading: const Icon(BootstrapIcons.moonFill),
      onChanged: (value) =>
          onChanged(value ? AppThemeMode.dark : AppThemeMode.system),
    );
  }
}
