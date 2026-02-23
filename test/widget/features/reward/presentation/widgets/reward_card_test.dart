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
  title: 'ケーキ',
  targetPoints: 300,
  category: RewardCategory.food,
  createdAt: DateTime(2026),
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
    testWidgets('displays reward title', (tester) async {
      await pumpRewardCard(tester, reward: _baseReward, currentPoints: 100);

      expect(find.text('ケーキ'), findsOneWidget);
    });

    testWidgets('displays category badge when category is set', (tester) async {
      await pumpRewardCard(tester, reward: _baseReward, currentPoints: 100);

      expect(find.text('食'), findsOneWidget);
      expect(find.byType(PrimaryBadge), findsOneWidget);
    });

    testWidgets('does not display category badge when category is null', (
      tester,
    ) async {
      final reward = Reward(
        id: 2,
        title: 'ギフトカード',
        targetPoints: 500,
        createdAt: DateTime(2026),
      );

      await pumpRewardCard(tester, reward: reward, currentPoints: 100);

      expect(find.byType(PrimaryBadge), findsNothing);
    });

    testWidgets('displays RewardProgressBar', (tester) async {
      await pumpRewardCard(tester, reward: _baseReward, currentPoints: 100);

      expect(find.byType(RewardProgressBar), findsOneWidget);
    });

    testWidgets('shows placeholder icon when imageUri is null', (tester) async {
      await pumpRewardCard(tester, reward: _baseReward, currentPoints: 100);

      expect(find.byIcon(BootstrapIcons.gift), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      var tapCount = 0;

      await pumpRewardCard(
        tester,
        reward: _baseReward,
        currentPoints: 100,
        onTap: () => tapCount++,
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(tapCount, 1);
    });
  });
}
