import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_card.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_progress_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _baseReward = Reward(
  id: 1,
  title: '好きなスイーツ',
  targetPoints: 200,
  category: RewardCategory.food,
  createdAt: DateTime(2026, 2),
);

Future<void> pumpRewardCard(
  WidgetTester tester, {
  required Reward reward,
  required int currentPoints,
  VoidCallback? onTap,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: RewardCard(
          reward: reward,
          currentPoints: currentPoints,
          onTap: onTap,
        ),
      ),
    ),
  );
}

void main() {
  group('RewardCard', () {
    testWidgets('should display reward title', (tester) async {
      await pumpRewardCard(
        tester,
        reward: _baseReward,
        currentPoints: 150,
      );

      expect(find.text('好きなスイーツ'), findsOneWidget);
    });

    testWidgets('should contain RewardProgressBar', (tester) async {
      await pumpRewardCard(
        tester,
        reward: _baseReward,
        currentPoints: 150,
      );

      expect(find.byType(RewardProgressBar), findsOneWidget);
    });

    testWidgets('should display category label when category is not null',
        (tester) async {
      await pumpRewardCard(
        tester,
        reward: _baseReward,
        currentPoints: 150,
      );

      expect(find.text('食'), findsOneWidget);
    });

    testWidgets('should not display category label when category is null',
        (tester) async {
      final rewardWithoutCategory = Reward(
        id: 2,
        title: 'カテゴリなしご褒美',
        targetPoints: 100,
        createdAt: DateTime(2026, 2),
      );

      await pumpRewardCard(
        tester,
        reward: rewardWithoutCategory,
        currentPoints: 50,
      );

      expect(find.byType(SecondaryBadge), findsNothing);
    });

    testWidgets('should call onTap callback when tapped', (tester) async {
      var callCount = 0;

      await pumpRewardCard(
        tester,
        reward: _baseReward,
        currentPoints: 150,
        onTap: () => callCount++,
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(callCount, equals(1));
    });
  });
}
