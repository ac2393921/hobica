import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/app.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/mocks/mock_overrides.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  group('HobicaApp', () {
    testWidgets('アプリが正常に起動する', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: mockRepositoryOverrides,
          child: const HobicaApp(),
        ),
      );

      expect(find.byType(HobicaApp), findsOneWidget);
    });

    testWidgets('ShadcnApp.routerを使用している', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: mockRepositoryOverrides,
          child: const HobicaApp(),
        ),
      );

      expect(find.byType(ShadcnApp), findsOneWidget);
    });

    testWidgets('モックRepository使用時にデータベースエラーが発生しない', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: mockRepositoryOverrides,
          child: const HobicaApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HobicaApp), findsOneWidget);
    });
  });

  group('AppThemeModeX', () {
    test('AppThemeMode.light を ThemeMode.light に変換する', () {
      expect(AppThemeMode.light.toFlutterThemeMode(), ThemeMode.light);
    });

    test('AppThemeMode.dark を ThemeMode.dark に変換する', () {
      expect(AppThemeMode.dark.toFlutterThemeMode(), ThemeMode.dark);
    });

    test('AppThemeMode.system を ThemeMode.system に変換する', () {
      expect(AppThemeMode.system.toFlutterThemeMode(), ThemeMode.system);
    });
  });
}
