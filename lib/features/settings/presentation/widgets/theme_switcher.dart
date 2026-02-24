import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    required this.currentMode,
    required this.onChanged,
    super.key,
  });

  static const String labelLight = 'ライト';
  static const String labelDark = 'ダーク';
  static const String labelSystem = 'システム';

  static const double _buttonSpacing = 8;

  final AppThemeMode currentMode;
  final ValueChanged<AppThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ThemeModeButton(
          label: labelLight,
          isSelected: currentMode == AppThemeMode.light,
          onTap: () => onChanged(AppThemeMode.light),
        ),
        const SizedBox(width: _buttonSpacing),
        _ThemeModeButton(
          label: labelDark,
          isSelected: currentMode == AppThemeMode.dark,
          onTap: () => onChanged(AppThemeMode.dark),
        ),
        const SizedBox(width: _buttonSpacing),
        _ThemeModeButton(
          label: labelSystem,
          isSelected: currentMode == AppThemeMode.system,
          onTap: () => onChanged(AppThemeMode.system),
        ),
      ],
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Button.primary(onPressed: onTap, child: Text(label))
        : Button.outline(onPressed: onTap, child: Text(label));
  }
}
