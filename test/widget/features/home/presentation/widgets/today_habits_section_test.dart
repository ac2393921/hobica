import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_card.dart';
import 'package:hobica/features/home/presentation/widgets/today_habits_section.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _testHabit1 = Habit(
  id: 1,
  title: '読書 30分',
  points: 30,
  frequencyType: FrequencyType.daily,
  frequencyValue: 1,
  createdAt: DateTime(2026),
);

final _testHabit2 = Habit(
  id: 2,
  title: 'ランニング',
  points: 50,
  frequencyType: FrequencyType.weekly,
  frequencyValue: 3,
  createdAt: DateTime(2026),
);

Future<void> pumpTodayHabitsSection(
  WidgetTester tester, {
  required List<Habit> habits,
  required void Function(int) onComplete,
  Set<int> completedIds = const <int>{},
  VoidCallback? onAddHabit,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: SingleChildScrollView(
          child: TodayHabitsSection(
            habits: habits,
            completedIds: completedIds,
            onComplete: onComplete,
            onAddHabit: onAddHabit,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('TodayHabitsSection', () {
    testWidgets('セクションタイトルを表示する', (tester) async {
      await pumpTodayHabitsSection(
        tester,
        habits: [_testHabit1],
        onComplete: (_) {},
      );

      expect(find.text('今日の習慣'), findsOneWidget);
    });

    testWidgets('習慣ごとに HabitCard を表示する', (tester) async {
      await pumpTodayHabitsSection(
        tester,
        habits: [_testHabit1, _testHabit2],
        onComplete: (_) {},
      );

      expect(find.byType(HabitCard), findsNWidgets(2));
    });

    testWidgets('習慣が空のとき空メッセージを表示する', (tester) async {
      await pumpTodayHabitsSection(
        tester,
        habits: const [],
        onComplete: (_) {},
      );

      expect(find.text('今日の習慣がありません'), findsOneWidget);
      expect(find.byType(HabitCard), findsNothing);
    });

    testWidgets('onAddHabit が非 null のとき追加ボタンを表示する', (tester) async {
      await pumpTodayHabitsSection(
        tester,
        habits: [_testHabit1],
        onComplete: (_) {},
        onAddHabit: () {},
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('追加ボタンタップで onAddHabit が1回呼ばれる', (tester) async {
      var callCount = 0;

      await pumpTodayHabitsSection(
        tester,
        habits: [_testHabit1],
        onComplete: (_) {},
        onAddHabit: () => callCount++,
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(callCount, equals(1));
    });

    testWidgets('onAddHabit が null のとき追加ボタンを表示しない', (tester) async {
      await pumpTodayHabitsSection(
        tester,
        habits: [_testHabit1],
        onComplete: (_) {},
      );

      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('未達成習慣の完了ボタンタップで onComplete が正しい habitId で呼ばれる',
        (tester) async {
      var callCount = 0;
      var calledId = -1;

      await pumpTodayHabitsSection(
        tester,
        habits: [_testHabit1],
        onComplete: (id) {
          callCount++;
          calledId = id;
        },
      );

      await tester.tap(find.byType(Button));
      await tester.pump();

      expect(callCount, equals(1));
      expect(calledId, equals(1));
    });

    testWidgets('達成済み習慣は完了ボタンが表示されない', (tester) async {
      await pumpTodayHabitsSection(
        tester,
        habits: [_testHabit1],
        completedIds: const <int>{1},
        onComplete: (_) {},
      );

      expect(find.byType(Button), findsNothing);
    });
  });
}
