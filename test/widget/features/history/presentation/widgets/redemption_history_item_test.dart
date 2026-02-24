import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/history/presentation/widgets/redemption_history_item.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _baseRedemption = RewardRedemption(
  id: 1,
  rewardId: 7,
  pointsSpent: 100,
  redeemedAt: DateTime(2026, 2, 1),
);

Future<void> pumpRedemptionHistoryItem(
  WidgetTester tester, {
  required RewardRedemption redemption,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: RedemptionHistoryItem(redemption: redemption),
      ),
    ),
  );
}

void main() {
  group('RedemptionHistoryItem', () {
    testWidgets('交換日を表示する', (tester) async {
      await pumpRedemptionHistoryItem(tester, redemption: _baseRedemption);

      expect(find.text('2026/02/01'), findsOneWidget);
    });

    testWidgets('ご褒美IDを表示する', (tester) async {
      await pumpRedemptionHistoryItem(tester, redemption: _baseRedemption);

      expect(find.text('ご褒美ID: 7'), findsOneWidget);
    });

    testWidgets('使用ポイントを "Xpt" 形式で表示する', (tester) async {
      await pumpRedemptionHistoryItem(tester, redemption: _baseRedemption);

      expect(find.text('100pt'), findsOneWidget);
    });

    testWidgets('SecondaryBadge でポイントを表示する', (tester) async {
      await pumpRedemptionHistoryItem(tester, redemption: _baseRedemption);

      expect(find.byType(SecondaryBadge), findsOneWidget);
    });
  });
}
