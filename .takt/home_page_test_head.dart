import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_card.dart';
import 'package:hobica/features/home/presentation/pages/home_page.dart';
import 'package:hobica/features/home/presentation/widgets/today_habits_section.dart';
import 'package:hobica/features/home/presentation/widgets/top_rewards_section.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_card.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/habit_repository_provider.dart';
import 'package:hobica/mocks/history_repository_provider.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:hobica/mocks/mock_history_repository.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';
import 'package:hobica/mocks/reward_repository_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

/// ProviderScope + ShadcnApp で HomePage をポンプするヘルパー関数。
Future<void> pumpHomePage(
  WidgetTester tester, {
  MockHabitRepository? mockHabitRepo,
  MockHistoryRepository? mockHistoryRepo,
  MockRewardRepository? mockRewardRepo,
  MockWalletRepository? mockWalletRepo,
}) async {
  final habitRepo = mockHabitRepo ?? MockHabitRepository();
  final historyRepo = mockHistoryRepo ?? MockHistoryRepository();
  final rewardRepo = mockRewardRepo ?? MockRewardRepository();
  final walletRepo = mockWalletRepo ?? MockWalletRepository();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        habitRepositoryProvider.overrideWithValue(habitRepo),
        historyRepositoryProvider.overrideWithValue(historyRepo),
        rewardRepositoryProvider.overrideWithValue(rewardRepo),
        walletRepositoryProvider.overrideWithValue(walletRepo),
      ],
      child: ShadcnApp(
        theme: _testTheme,
        home: const Scaffold(child: HomePage()),
      ),
    ),
  );
}

void main() {
  group('HomePage', () {
    testWidgets('ローディング中は LoadingIndicator を表示する', (tester) async {
      await pumpHomePage(tester);

      // pump 直後（非同期完了前）はローディング中
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('習慣一覧を HabitCard で表示する', (tester) async {
      await pumpHomePage(tester);
      await tester.pumpAndSettle();

      // MockHabitRepository にはデフォルトで2件の習慣がある
      expect(find.byType(HabitCard), findsAtLeastNWidgets(1));
      expect(find.text('読書 30分'), findsOneWidget);
      expect(find.text('ランニング'), findsOneWidget);
    });

    testWidgets('TodayHabitsSection と TopRewardsSection が表示される', (tester) async {
      await pumpHomePage(tester);
      await tester.pumpAndSettle();

      expect(find.byType(TodayHabitsSection), findsOneWidget);
      expect(find.byType(TopRewardsSection), findsOneWidget);
    });

    testWidgets('セクションヘッダーが表示される', (tester) async {
      await pumpHomePage(tester);
      await tester.pumpAndSettle();

      expect(find.text('今日の習慣'), findsOneWidget);
      expect(find.text('ご褒美'), findsOneWidget);
    });

    testWidgets('ご褒美が存在する場合は RewardCard を表示する', (tester) async {
      final rewardRepo = MockRewardRepository();
      await rewardRepo.createReward(title: 'スイーツ', targetPoints: 100);
      await rewardRepo.createReward(title: '映画鑑賞', targetPoints: 200);

      await pumpHomePage(tester, mockRewardRepo: rewardRepo);
      await tester.pumpAndSettle();

      expect(find.byType(RewardCard), findsAtLeastNWidgets(1));
      expect(find.text('スイーツ'), findsOneWidget);
    });

    testWidgets('ご褒美が4件以上あっても最大3件のみ表示する', (tester) async {
      final rewardRepo = MockRewardRepository();
      for (var i = 1; i <= 4; i++) {
        await rewardRepo.createReward(title: 'Reward $i', targetPoints: 100);
      }

      await pumpHomePage(tester, mockRewardRepo: rewardRepo);
      await tester.pumpAndSettle();

      expect(find.byType(RewardCard), findsNWidgets(3));
    });

    testWidgets('ご褒美が空のときは空メッセージを表示する', (tester) async {
      // MockRewardRepository はデフォルトで空
      await pumpHomePage(tester);
      await tester.pumpAndSettle();

      expect(find.text('ご褒美がありません'), findsOneWidget);
    });

    testWidgets('ウォレット残高が AppBar に表示される', (tester) async {
      final walletRepo = MockWalletRepository();
      await walletRepo.addPoints(150);

      await pumpHomePage(tester, mockWalletRepo: walletRepo);
      await tester.pumpAndSettle();

      expect(find.text('150pt'), findsOneWidget);
    });

    testWidgets('AppBar にホームタイトルが表示される', (tester) async {
      await pumpHomePage(tester);
      await tester.pumpAndSettle();

      expect(find.text('ホーム'), findsAtLeastNWidgets(1));
    });
  });
}
