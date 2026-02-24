import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/widgets/loading_indicator.dart';
import 'package:hobica/features/settings/presentation/pages/settings_page.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:hobica/features/settings/presentation/widgets/theme_switcher.dart';
import 'package:hobica/mocks/mock_settings_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _testRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const SettingsPage(),
    ),
    GoRoute(
      path: '/settings/premium',
      name: 'Premium',
      builder: (_, __) => const Scaffold(child: Text('プレミアム')),
    ),
  ],
);

Future<void> pumpSettingsPage(
  WidgetTester tester, {
  MockSettingsRepository? settingsRepo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (settingsRepo != null)
          settingsRepositoryProvider.overrideWithValue(settingsRepo),
      ],
      child: ShadcnApp.router(
        theme: _testTheme,
        routerConfig: _testRouter,
      ),
    ),
  );
}

void main() {
  group('SettingsPage', () {
    testWidgets('ローディング中は LoadingIndicator を表示する', (tester) async {
      await pumpSettingsPage(tester);

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('データロード後に "設定" タイトルを表示する', (tester) async {
      await pumpSettingsPage(tester);
      await tester.pump();

      expect(find.text('設定'), findsOneWidget);
    });

    testWidgets('ThemeSwitcher を表示する', (tester) async {
      await pumpSettingsPage(tester);
      await tester.pump();

      expect(find.byType(ThemeSwitcher), findsOneWidget);
    });

    testWidgets('通知トグル（Switch）を表示する', (tester) async {
      await pumpSettingsPage(tester);
      await tester.pump();

      expect(find.byType(Switch), findsAtLeastNWidgets(2));
    });

    testWidgets('「プレミアムにアップグレード」テキストを表示する', (tester) async {
      await pumpSettingsPage(tester);
      await tester.pump();

      expect(find.text('プレミアムにアップグレード'), findsOneWidget);
    });

    testWidgets('「データをエクスポート」「データをインポート」を表示する', (tester) async {
      await pumpSettingsPage(tester);
      await tester.pump();

      expect(find.text('データをエクスポート'), findsOneWidget);
      expect(find.text('データをインポート'), findsOneWidget);
    });

    testWidgets('「利用規約」「プライバシーポリシー」「アプリについて」を表示する', (tester) async {
      await pumpSettingsPage(tester);
      await tester.pump();

      expect(find.text('利用規約'), findsOneWidget);
      expect(find.text('プライバシーポリシー'), findsOneWidget);
      expect(find.text('アプリについて'), findsOneWidget);
    });

    testWidgets('通知トグルをタップすると notificationsEnabled が切り替わる', (tester) async {
      final repo = MockSettingsRepository();
      await pumpSettingsPage(tester, settingsRepo: repo);
      await tester.pump();

      final notificationSwitch = find.byType(Switch).at(1);
      await tester.tap(notificationSwitch);
      await tester.pump();

      final settings = await repo.getSettings();
      expect(settings.notificationsEnabled, false);
    });
  });
}
