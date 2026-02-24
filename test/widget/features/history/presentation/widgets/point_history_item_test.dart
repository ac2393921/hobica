import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/presentation/widgets/point_history_item.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _baseLog = HabitLog(
  id: 1,
  habitId: 42,
  date: DateTime(2026, 2, 20),
  points: 30,
  createdAt: DateTime(2026, 2, 20),
);

Future<void> pumpPointHistoryItem(
  WidgetTester tester, {
  required HabitLog log,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: PointHistoryItem(log: log),
      ),
    ),
  );
}

void main() {
  group('PointHistoryItem', () {
    testWidgets('日付を表示する', (tester) async {
      await pumpPointHistoryItem(tester, log: _baseLog);

      expect(find.text('2026/02/20'), findsOneWidget);
    });

    testWidgets('習慣IDを表示する', (tester) async {
      await pumpPointHistoryItem(tester, log: _baseLog);

      expect(find.text('習慣ID: 42'), findsOneWidget);
    });

    testWidgets('ポイントを "+Xpt" 形式で表示する', (tester) async {
      await pumpPointHistoryItem(tester, log: _baseLog);

      expect(find.text('+30pt'), findsOneWidget);
    });

    testWidgets('PrimaryBadge でポイントを表示する', (tester) async {
      await pumpPointHistoryItem(tester, log: _baseLog);

      expect(find.byType(PrimaryBadge), findsOneWidget);
    });
  });
}
