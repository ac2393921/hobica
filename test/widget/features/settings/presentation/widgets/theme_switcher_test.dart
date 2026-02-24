import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/presentation/widgets/theme_switcher.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> _pumpThemeSwitcher(
  WidgetTester tester, {
  required AppThemeMode currentMode,
  required ValueChanged<AppThemeMode> onChanged,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: ThemeSwitcher(
          currentMode: currentMode,
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

void main() {
  group('ThemeSwitcher', () {
    testWidgets('displays all three theme mode labels', (tester) async {
      await _pumpThemeSwitcher(
        tester,
        currentMode: AppThemeMode.system,
        onChanged: (_) {},
      );

      expect(find.text(ThemeSwitcher.labelLight), findsOneWidget);
      expect(find.text(ThemeSwitcher.labelDark), findsOneWidget);
      expect(find.text(ThemeSwitcher.labelSystem), findsOneWidget);
    });

    testWidgets('calls onChanged with light when ライト button is tapped',
        (tester) async {
      AppThemeMode? changedMode;

      await _pumpThemeSwitcher(
        tester,
        currentMode: AppThemeMode.system,
        onChanged: (mode) => changedMode = mode,
      );

      await tester.tap(find.text(ThemeSwitcher.labelLight));
      await tester.pump();

      expect(changedMode, AppThemeMode.light);
    });

    testWidgets('calls onChanged with dark when ダーク button is tapped',
        (tester) async {
      AppThemeMode? changedMode;

      await _pumpThemeSwitcher(
        tester,
        currentMode: AppThemeMode.system,
        onChanged: (mode) => changedMode = mode,
      );

      await tester.tap(find.text(ThemeSwitcher.labelDark));
      await tester.pump();

      expect(changedMode, AppThemeMode.dark);
    });

    testWidgets('calls onChanged with system when システム button is tapped',
        (tester) async {
      AppThemeMode? changedMode;

      await _pumpThemeSwitcher(
        tester,
        currentMode: AppThemeMode.light,
        onChanged: (mode) => changedMode = mode,
      );

      await tester.tap(find.text(ThemeSwitcher.labelSystem));
      await tester.pump();

      expect(changedMode, AppThemeMode.system);
    });

    testWidgets('renders 3 Button widgets in total', (tester) async {
      await _pumpThemeSwitcher(
        tester,
        currentMode: AppThemeMode.light,
        onChanged: (_) {},
      );

      expect(find.byType(Button), findsNWidgets(3));
    });
  });
}
