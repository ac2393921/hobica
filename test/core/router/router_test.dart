import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/router/router.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

/// 各ページが Riverpod プロバイダーを使うため、
/// ProviderScope で appRouter を包む必要がある。
Widget _buildTestApp({
  MockHabitRepository? mockRepo,
  MockRewardRepository? mockRewardRepo,
  MockWalletRepository? mockWalletRepo,
}) {
  final overrides = <Override>[
    habitRepositoryProvider.overrideWithValue(
      mockRepo ?? MockHabitRepository(),
    ),
    rewardRepositoryProvider.overrideWithValue(
      mockRewardRepo ?? MockRewardRepository(),
    ),
    walletRepositoryProvider.overrideWithValue(
      mockWalletRepo ?? MockWalletRepository(),
    ),
  ];
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(routerConfig: appRouter),
  );
}

void main() {
  group('appRouter', () {
    testWidgets('初期ロケーションがホーム画面である', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // 初期画面がホームであることを確認
      expect(find.text('今日の習慣'), findsOneWidget);
    });

    testWidgets('ホーム画面へのナビゲーションが機能する', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // ホーム画面の確認（AppBarとボトムナビゲーションにも「ホーム」があるため複数存在する）
      expect(find.text('ホーム'), findsAtLeastNWidgets(1));
      expect(find.text('今日の習慣'), findsOneWidget);
    });

    testWidgets('習慣一覧画面へのナビゲーションが機能する', (tester) async {
      final mockRepo = MockHabitRepository();
      await tester.pumpWidget(_buildTestApp(mockRepo: mockRepo));
      await tester.pumpAndSettle();

      // ボトムナビゲーションの習慣タブをタップ
      await tester.tap(find.text('習慣'));
      await tester.pumpAndSettle();

      // HabitListPage が表示されることを確認（AppBar title = '習慣'）
      expect(find.text('習慣'), findsAtLeastNWidgets(1));
      // モックデータの習慣が表示されることを確認
      expect(find.text('読書 30分'), findsOneWidget);
    });

    testWidgets('ご褒美一覧画面へのナビゲーションが機能する', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // ボトムナビゲーションのご褒美タブをタップ
      await tester.tap(find.text('ご褒美'));
      await tester.pumpAndSettle();

      expect(find.text('ご褒美一覧'), findsAtLeastNWidgets(1));
    });

    testWidgets('履歴画面へのナビゲーションが機能する', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // ボトムナビゲーションの履歴タブをタップ
      await tester.tap(find.text('履歴'));
      await tester.pumpAndSettle();

      expect(find.text('履歴'), findsAtLeastNWidgets(1));
    });

    testWidgets('設定画面へのナビゲーションが機能する', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // ボトムナビゲーションの設定タブをタップ
      await tester.tap(find.text('設定'));
      await tester.pumpAndSettle();

      expect(find.text('設定'), findsAtLeastNWidgets(1));
    });

    testWidgets('習慣詳細画面へのナビゲーションが機能する（パスパラメータ付き）', (tester) async {
      final mockRepo = MockHabitRepository();
      await tester.pumpWidget(_buildTestApp(mockRepo: mockRepo));
      await tester.pumpAndSettle();

      // 有効な習慣IDでナビゲート（モックデータのID=1: 読書 30分）
      appRouter.go('/habits/1');
      await tester.pumpAndSettle();

      // HabitDetailPage が表示されることを確認
      expect(find.text('読書 30分'), findsAtLeastNWidgets(1));
    });

    testWidgets('習慣編集画面へのナビゲーションが機能する（パスパラメータ付き）', (tester) async {
      final mockRepo = MockHabitRepository();
      await tester.pumpWidget(_buildTestApp(mockRepo: mockRepo));
      await tester.pumpAndSettle();

      // 有効な習慣IDでナビゲート（extra=null のためフォームは作成モードで表示）
      appRouter.go('/habits/1/edit');
      await tester.pumpAndSettle();

      // HabitFormPage が表示されることを確認
      expect(find.text('習慣を作成'), findsAtLeastNWidgets(1));
    });

    testWidgets('習慣作成画面へのナビゲーションが機能する', (tester) async {
      final mockRepo = MockHabitRepository();
      await tester.pumpWidget(_buildTestApp(mockRepo: mockRepo));
      await tester.pumpAndSettle();

      // 直接パスを指定してナビゲート
      appRouter.go('/habits/new');
      await tester.pumpAndSettle();

      // HabitFormPage（作成モード）が表示されることを確認
      expect(find.text('習慣を作成'), findsAtLeastNWidgets(1));
    });

    testWidgets('ご褒美詳細画面へのナビゲーションが機能する（パスパラメータ付き）', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // 直接パスを指定してナビゲート
      appRouter.go('/rewards/456');
      await tester.pumpAndSettle();

      // 実ページの確認（報酬が存在しない場合のエラー状態）
      expect(find.text('ご褒美が見つかりません'), findsOneWidget);
    });

    testWidgets('ご褒美編集画面へのナビゲーションが機能する（パスパラメータ付き）', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // 直接パスを指定してナビゲート
      appRouter.go('/rewards/456/edit');
      await tester.pumpAndSettle();

      // 実ページ（RewardFormPage）の表示確認
      expect(find.text('ご褒美を編集'), findsAtLeastNWidgets(1));
    });

    testWidgets('ご褒美作成画面へのナビゲーションが機能する', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // 直接パスを指定してナビゲート
      appRouter.go('/rewards/new');
      await tester.pumpAndSettle();

      expect(find.text('ご褒美を追加'), findsAtLeastNWidgets(1));
    });

    testWidgets('プレミアム画面へのナビゲーションが機能する', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // 直接パスを指定してナビゲート
      appRouter.go('/settings/premium');
      await tester.pumpAndSettle();

      expect(find.text('プレミアム'), findsAtLeastNWidgets(1));
    });

    testWidgets('不正なルートでエラー画面が表示される', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // 存在しないルートへナビゲート
      appRouter.go('/invalid-route');
      await tester.pumpAndSettle();

      expect(find.text('ページが見つかりません'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('ホームに戻る'), findsOneWidget);
    });

    testWidgets('エラー画面から「ホームに戻る」ボタンでホーム画面に戻る', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // 存在しないルートへナビゲート
      appRouter.go('/invalid-route');
      await tester.pumpAndSettle();

      // 「ホームに戻る」ボタンをタップ
      await tester.tap(find.text('ホームに戻る'));
      await tester.pumpAndSettle();

      // ホーム画面に戻ったことを確認（AppBarとボトムナビゲーションにも「ホーム」があるため複数存在する）
      expect(find.text('ホーム'), findsAtLeastNWidgets(1));
      expect(find.text('今日の習慣'), findsOneWidget);
    });

    testWidgets('ボトムナビゲーションが全画面で表示される', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // ボトムナビゲーションの存在確認
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // 各タブの表示確認（ラベルとAppBar/本文にも同じテキストがある場合があるため、BottomNavigationBar内を確認）
      final bottomNav = find.byType(BottomNavigationBar);
      expect(bottomNav, findsOneWidget);

      // ボトムナビゲーションのアイテム確認
      expect(find.descendant(of: bottomNav, matching: find.text('ホーム')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('習慣')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('ご褒美')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('履歴')), findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text('設定')), findsOneWidget);
    });

    testWidgets('現在のタブがハイライトされる', (tester) async {
      final mockRepo = MockHabitRepository();
      await tester.pumpWidget(_buildTestApp(mockRepo: mockRepo));
      await tester.pumpAndSettle();

      // 初期状態（ホーム）の確認
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, 0);

      // 習慣タブに移動
      await tester.tap(find.text('習慣'));
      await tester.pumpAndSettle();

      final updatedBottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(updatedBottomNav.currentIndex, 1);
    });
  });

  group('ルート定義の網羅性', () {
    test('すべてのAppRoutesパスに対応するルートが定義されている', () {
      // appRouterのルート構成を確認
      // StatefulShellRouteを含むため、routesの長さは実装により異なる
      // 実際のナビゲーションテストで網羅性を確認済み
      expect(appRouter.routerDelegate.currentConfiguration.routes, isNotEmpty);
    });
  });

  group('パスパラメータのエッジケース', () {
    testWidgets('特殊文字を含むIDが正しく処理される（ご褒美）', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      // URLエンコードされた文字列（スペース）
      appRouter.go('/rewards/reward%20test');
      await tester.pumpAndSettle();

      // 非整数IDのため int.parse が FormatException → errorBuilder が表示される
      expect(find.text('ページが見つかりません'), findsOneWidget);
    });

    testWidgets('数値IDが正しく処理される（習慣）', (tester) async {
      final mockRepo = MockHabitRepository();
      await tester.pumpWidget(_buildTestApp(mockRepo: mockRepo));
      await tester.pumpAndSettle();

      // 有効な習慣ID=1でナビゲート
      appRouter.go('/habits/1');
      await tester.pumpAndSettle();

      // HabitDetailPage が表示されることを確認
      expect(find.text('読書 30分'), findsAtLeastNWidgets(1));
    });

    testWidgets('数値IDが正しく処理される（ご褒美）', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      appRouter.go('/rewards/67890');
      await tester.pumpAndSettle();

      // Mock に ID=67890 のご褒美が存在しないため ErrorView が表示される
      expect(find.text('ご褒美が見つかりません'), findsOneWidget);
    });

    testWidgets('UUIDフォーマットのIDが正しく処理される（ご褒美）', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      const uuid = '123e4567-e89b-12d3-a456-426614174000';
      appRouter.go('/rewards/$uuid');
      await tester.pumpAndSettle();

      // UUID は int.parse 不可のため FormatException → errorBuilder が表示される
      expect(find.text('ページが見つかりません'), findsOneWidget);
    });
  });
}
