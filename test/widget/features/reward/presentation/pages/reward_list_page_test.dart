import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/widgets/empty_view.dart';
import 'package:hobica/core/widgets/loading_indicator.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/presentation/pages/reward_list_page.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_card.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _testRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const RewardListPage(),
    ),
  ],
);

Future<void> pumpRewardListPage(
  WidgetTester tester, {
  MockRewardRepository? rewardRepo,
  MockWalletRepository? walletRepo,
}) async {
  // 常にモックを提供することでappDatabaseProviderへの依存を回避する
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        rewardRepositoryProvider.overrideWithValue(
          rewardRepo ?? MockRewardRepository(),
        ),
        walletRepositoryProvider.overrideWithValue(
          walletRepo ?? MockWalletRepository(),
        ),
      ],
      child: ShadcnApp.router(
        theme: _testTheme,
        routerConfig: _testRouter,
      ),
    ),
  );
}

void main() {
  group('RewardListPage', () {
    testWidgets('shows LoadingIndicator initially', (tester) async {
      await pumpRewardListPage(tester);

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('shows EmptyView when no rewards', (tester) async {
      final rewardRepo = MockRewardRepository();
      await pumpRewardListPage(tester, rewardRepo: rewardRepo);
      await tester.pump();

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('ご褒美がまだありません'), findsOneWidget);
    });

    testWidgets('shows list of RewardCards when rewards exist', (tester) async {
      final rewardRepo = MockRewardRepository();
      await rewardRepo.createReward(title: 'ケーキ', targetPoints: 300);
      await rewardRepo.createReward(
        title: '映画',
        targetPoints: 500,
        category: RewardCategory.entertainment,
      );

      await pumpRewardListPage(tester, rewardRepo: rewardRepo);
      await tester.pump();

      expect(find.byType(RewardCard), findsNWidgets(2));
      expect(find.text('ケーキ'), findsOneWidget);
      expect(find.text('映画'), findsOneWidget);
    });

    testWidgets('displays page title "ご褒美"', (tester) async {
      await pumpRewardListPage(tester);
      await tester.pump();

      expect(find.text('ご褒美'), findsOneWidget);
    });
  });
}
