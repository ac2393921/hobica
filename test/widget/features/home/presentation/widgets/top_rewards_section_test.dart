import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/home/presentation/widgets/top_rewards_section.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _testReward1 = Reward(
  id: 1,
  title: '好きなスイーツ',
  targetPoints: 100,
  createdAt: DateTime(2026),
);

final _testReward2 = Reward(
  id: 2,
  title: '映画鑑賞',
  targetPoints: 200,
  createdAt: DateTime(2026),
);

Future<void> pumpTopRewardsSection(
  WidgetTester tester, {
  required List<Reward> rewards,
  required int currentPoints,
  VoidCallback? onSeeAll,
  void Function(int rewardId)? onRewardTap,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: SingleChildScrollView(
          child: TopRewardsSection(
            rewards: rewards,
            currentPoints: currentPoints,
            onSeeAll: onSeeAll,
            onRewardTap: onRewardTap,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('TopRewardsSection', () {
    testWidgets('セクションタイトルを表示する', (tester) async {
      await pumpTopRewardsSection(
        tester,
        rewards: [_testReward1],
        currentPoints: 50,
      );

      expect(find.text('ご褒美'), findsOneWidget);
    });

    testWidgets('ご褒美ごとに RewardCard を表示する', (tester) async {
      await pumpTopRewardsSection(
        tester,
        rewards: [_testReward1, _testReward2],
        currentPoints: 50,
      );

      expect(find.byType(RewardCard), findsNWidgets(2));
    });

    testWidgets('ご褒美が空のとき空メッセージを表示する', (tester) async {
      await pumpTopRewardsSection(
        tester,
        rewards: const [],
        currentPoints: 50,
      );

      expect(find.text('ご褒美がありません'), findsOneWidget);
      expect(find.byType(RewardCard), findsNothing);
    });

    testWidgets('onSeeAll が非 null のとき「全て見る」を表示する', (tester) async {
      await pumpTopRewardsSection(
        tester,
        rewards: [_testReward1],
        currentPoints: 50,
        onSeeAll: () {},
      );

      expect(find.text('全て見る'), findsOneWidget);
    });

    testWidgets('onSeeAll が null のとき「全て見る」を表示しない', (tester) async {
      await pumpTopRewardsSection(
        tester,
        rewards: [_testReward1],
        currentPoints: 50,
      );

      expect(find.text('全て見る'), findsNothing);
    });

    testWidgets('「全て見る」タップで onSeeAll が1回呼ばれる', (tester) async {
      var callCount = 0;

      await pumpTopRewardsSection(
        tester,
        rewards: [_testReward1],
        currentPoints: 50,
        onSeeAll: () => callCount++,
      );

      await tester.tap(find.text('全て見る'));
      await tester.pump();

      expect(callCount, equals(1));
    });

    testWidgets('RewardCard タップで onRewardTap が正しい rewardId で呼ばれる',
        (tester) async {
      var callCount = 0;
      var calledId = -1;

      await pumpTopRewardsSection(
        tester,
        rewards: [_testReward1],
        currentPoints: 50,
        onRewardTap: (id) {
          callCount++;
          calledId = id;
        },
      );

      await tester.tap(find.byType(RewardCard).first);
      await tester.pump();

      expect(callCount, equals(1));
      expect(calledId, equals(1));
    });
  });
}
