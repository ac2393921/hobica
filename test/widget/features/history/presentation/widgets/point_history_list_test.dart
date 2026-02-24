import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets/empty_view.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/presentation/widgets/point_history_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> pumpPointHistoryList(
  WidgetTester tester, {
  required List<HabitLog> habitLogs,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: PointHistoryList(habitLogs: habitLogs),
      ),
    ),
  );
}

void main() {
  group('PointHistoryList', () {
    testWidgets('shows EmptyView when habitLogs is empty', (tester) async {
      await pumpPointHistoryList(tester, habitLogs: []);

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('ポイント獲得履歴がありません'), findsOneWidget);
    });

    testWidgets('shows date header for each group', (tester) async {
      final logs = [
        HabitLog(
          id: 1,
          habitId: 1,
          date: DateTime(2026, 2, 20),
          points: 30,
          createdAt: DateTime(2026, 2, 20),
        ),
      ];

      await pumpPointHistoryList(tester, habitLogs: logs);

      expect(find.text('2026年2月20日'), findsOneWidget);
    });

    testWidgets('shows points with + prefix for each log', (tester) async {
      final logs = [
        HabitLog(
          id: 1,
          habitId: 1,
          date: DateTime(2026, 2, 20),
          points: 30,
          createdAt: DateTime(2026, 2, 20),
        ),
      ];

      await pumpPointHistoryList(tester, habitLogs: logs);

      expect(find.text('+30pt'), findsOneWidget);
    });

    testWidgets('groups logs by date into separate sections', (tester) async {
      final logs = [
        HabitLog(
          id: 1,
          habitId: 1,
          date: DateTime(2026, 2, 20),
          points: 30,
          createdAt: DateTime(2026, 2, 20),
        ),
        HabitLog(
          id: 2,
          habitId: 2,
          date: DateTime(2026, 2, 21),
          points: 50,
          createdAt: DateTime(2026, 2, 21),
        ),
      ];

      await pumpPointHistoryList(tester, habitLogs: logs);

      expect(find.text('2026年2月20日'), findsOneWidget);
      expect(find.text('2026年2月21日'), findsOneWidget);
      expect(find.text('+30pt'), findsOneWidget);
      expect(find.text('+50pt'), findsOneWidget);
    });

    testWidgets('does not show EmptyView when habitLogs is not empty',
        (tester) async {
      final logs = [
        HabitLog(
          id: 1,
          habitId: 1,
          date: DateTime(2026, 2, 20),
          points: 30,
          createdAt: DateTime(2026, 2, 20),
        ),
      ];

      await pumpPointHistoryList(tester, habitLogs: logs);

      expect(find.byType(EmptyView), findsNothing);
    });
  });
}
