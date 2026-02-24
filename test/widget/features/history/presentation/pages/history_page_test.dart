import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets/error_view.dart';
import 'package:hobica/core/widgets/loading_indicator.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/presentation/pages/history_page.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/history/presentation/widgets/point_history_list.dart';
import 'package:hobica/features/history/presentation/widgets/redemption_history_list.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/mock_history_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _testHabitLogs = [
  HabitLog(
    id: 1,
    habitId: 1,
    date: DateTime(2026, 2, 20),
    points: 30,
    createdAt: DateTime(2026, 2, 20),
  ),
];

final _testRedemptions = [
  RewardRedemption(
    id: 1,
    rewardId: 1,
    pointsSpent: 100,
    redeemedAt: DateTime(2026, 2, 1),
  ),
];

Future<void> pumpHistoryPage(
  WidgetTester tester, {
  List<HabitLog> habitLogs = const [],
  List<RewardRedemption> redemptions = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        historyRepositoryProvider.overrideWithValue(
          MockHistoryRepository(
            habitLogs: habitLogs,
            redemptions: redemptions,
          ),
        ),
      ],
      child: ShadcnApp(
        theme: _testTheme,
        home: const HistoryPage(),
      ),
    ),
  );
}

void main() {
  group('HistoryPage', () {
    testWidgets('shows AppBar with title "履歴"', (tester) async {
      await pumpHistoryPage(tester);
      await tester.pump();

      expect(find.text('履歴'), findsOneWidget);
    });

    testWidgets('shows LoadingIndicator while loading', (tester) async {
      await pumpHistoryPage(tester);

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('shows tab bar after data is loaded', (tester) async {
      await pumpHistoryPage(
        tester,
        habitLogs: _testHabitLogs,
        redemptions: _testRedemptions,
      );
      await tester.pumpAndSettle();

      expect(find.text('ポイント獲得'), findsOneWidget);
      expect(find.text('交換'), findsOneWidget);
    });

    testWidgets('shows PointHistoryList by default', (tester) async {
      await pumpHistoryPage(
        tester,
        habitLogs: _testHabitLogs,
        redemptions: _testRedemptions,
      );
      await tester.pumpAndSettle();

      expect(find.byType(PointHistoryList), findsOneWidget);
      expect(find.byType(RedemptionHistoryList), findsNothing);
    });

    testWidgets('shows RedemptionHistoryList after tapping 交換 tab',
        (tester) async {
      await pumpHistoryPage(
        tester,
        habitLogs: _testHabitLogs,
        redemptions: _testRedemptions,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('交換'));
      await tester.pump();

      expect(find.byType(RedemptionHistoryList), findsOneWidget);
      expect(find.byType(PointHistoryList), findsNothing);
    });

    testWidgets('shows PointHistoryList after switching back to ポイント獲得 tab',
        (tester) async {
      await pumpHistoryPage(
        tester,
        habitLogs: _testHabitLogs,
        redemptions: _testRedemptions,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('交換'));
      await tester.pump();
      await tester.tap(find.text('ポイント獲得'));
      await tester.pump();

      expect(find.byType(PointHistoryList), findsOneWidget);
      expect(find.byType(RedemptionHistoryList), findsNothing);
    });

    testWidgets('shows ErrorView when provider returns an error',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyProvider.overrideWith(
              _ErrorHistory.new,
            ),
          ],
          child: ShadcnApp(
            theme: _testTheme,
            home: const HistoryPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
    });
  });
}

class _ErrorHistory extends History {
  @override
  Future<HistoryState> build() async {
    throw Exception('test error');
  }
}
