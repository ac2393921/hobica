import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets/empty_view.dart';
import 'package:hobica/features/history/presentation/widgets/redemption_history_list.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> pumpRedemptionHistoryList(
  WidgetTester tester, {
  required List<RewardRedemption> redemptions,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: RedemptionHistoryList(redemptions: redemptions),
      ),
    ),
  );
}

void main() {
  group('RedemptionHistoryList', () {
    testWidgets('shows EmptyView when redemptions is empty', (tester) async {
      await pumpRedemptionHistoryList(tester, redemptions: []);

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('交換履歴がありません'), findsOneWidget);
    });

    testWidgets('shows date header for each group', (tester) async {
      final redemptions = [
        RewardRedemption(
          id: 1,
          rewardId: 1,
          pointsSpent: 100,
          redeemedAt: DateTime(2026, 2, 1),
        ),
      ];

      await pumpRedemptionHistoryList(tester, redemptions: redemptions);

      expect(find.text('2026年2月1日'), findsOneWidget);
    });

    testWidgets('shows points with - prefix for each redemption',
        (tester) async {
      final redemptions = [
        RewardRedemption(
          id: 1,
          rewardId: 1,
          pointsSpent: 100,
          redeemedAt: DateTime(2026, 2, 1),
        ),
      ];

      await pumpRedemptionHistoryList(tester, redemptions: redemptions);

      expect(find.text('-100pt'), findsOneWidget);
    });

    testWidgets('groups redemptions by date into separate sections',
        (tester) async {
      final redemptions = [
        RewardRedemption(
          id: 1,
          rewardId: 1,
          pointsSpent: 100,
          redeemedAt: DateTime(2026, 2, 1),
        ),
        RewardRedemption(
          id: 2,
          rewardId: 2,
          pointsSpent: 200,
          redeemedAt: DateTime(2026, 2, 5),
        ),
      ];

      await pumpRedemptionHistoryList(tester, redemptions: redemptions);

      expect(find.text('2026年2月1日'), findsOneWidget);
      expect(find.text('2026年2月5日'), findsOneWidget);
      expect(find.text('-100pt'), findsOneWidget);
      expect(find.text('-200pt'), findsOneWidget);
    });

    testWidgets('does not show EmptyView when redemptions is not empty',
        (tester) async {
      final redemptions = [
        RewardRedemption(
          id: 1,
          rewardId: 1,
          pointsSpent: 100,
          redeemedAt: DateTime(2026, 2, 1),
        ),
      ];

      await pumpRedemptionHistoryList(tester, redemptions: redemptions);

      expect(find.byType(EmptyView), findsNothing);
    });
  });
}
