import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/pages/reward_detail_page.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_progress_bar.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> pumpRewardDetailPage(
  WidgetTester tester, {
  required int rewardId,
  MockRewardRepository? rewardRepo,
  MockWalletRepository? walletRepo,
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => RewardDetailPage(rewardId: rewardId),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (rewardRepo != null)
          rewardRepositoryProvider.overrideWithValue(rewardRepo),
        if (walletRepo != null)
          walletRepositoryProvider.overrideWithValue(walletRepo),
      ],
      child: ShadcnApp.router(
        theme: _testTheme,
        routerConfig: router,
      ),
    ),
  );
}

void main() {
  group('RewardDetailPage', () {
    testWidgets('shows reward title', (tester) async {
      final rewardRepo = MockRewardRepository();
      final result = await rewardRepo.createReward(
        title: 'ケーキ',
        targetPoints: 300,
      );
      final rewardId = (result as Success<Reward, dynamic>).value.id;

      await pumpRewardDetailPage(
        tester,
        rewardId: rewardId,
        rewardRepo: rewardRepo,
      );
      await tester.pump();

      expect(find.text('ケーキ'), findsWidgets);
    });

    testWidgets('shows target points', (tester) async {
      final rewardRepo = MockRewardRepository();
      final result = await rewardRepo.createReward(
        title: 'ケーキ',
        targetPoints: 300,
      );
      final rewardId = (result as Success<Reward, dynamic>).value.id;

      await pumpRewardDetailPage(
        tester,
        rewardId: rewardId,
        rewardRepo: rewardRepo,
      );
      await tester.pump();

      expect(find.text('必要ポイント: 300 pt'), findsOneWidget);
    });

    testWidgets('shows RewardProgressBar', (tester) async {
      final rewardRepo = MockRewardRepository();
      final result = await rewardRepo.createReward(
        title: 'ケーキ',
        targetPoints: 300,
      );
      final rewardId = (result as Success<Reward, dynamic>).value.id;

      await pumpRewardDetailPage(
        tester,
        rewardId: rewardId,
        rewardRepo: rewardRepo,
      );
      await tester.pump();

      expect(find.byType(RewardProgressBar), findsOneWidget);
    });

    testWidgets('shows error when reward not found', (tester) async {
      final rewardRepo = MockRewardRepository();

      await pumpRewardDetailPage(
        tester,
        rewardId: 999,
        rewardRepo: rewardRepo,
      );
      await tester.pump();

      expect(find.text('ご褒美が見つかりません'), findsOneWidget);
    });

    testWidgets('redeem button is disabled when points insufficient',
        (tester) async {
      final rewardRepo = MockRewardRepository();
      final walletRepo = MockWalletRepository(); // 0 points initially

      final result = await rewardRepo.createReward(
        title: 'ケーキ',
        targetPoints: 300,
      );
      final rewardId = (result as Success<Reward, dynamic>).value.id;

      await pumpRewardDetailPage(
        tester,
        rewardId: rewardId,
        rewardRepo: rewardRepo,
        walletRepo: walletRepo,
      );
      await tester.pump();

      // 交換するボタンが disabled であること（onPressed が null）
      final button = tester.widget<Button>(
        find.widgetWithText(Button, '交換する'),
      );
      expect(button.onPressed, isNull);
    });
  });
}
