import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_card.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_streak_indicator.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _baseHabit = Habit(
  id: 1,
  title: '読書 30分',
  points: 30,
  frequencyType: FrequencyType.daily,
  frequencyValue: 1,
  createdAt: DateTime(2024),
);

Future<void> pumpHabitCard(
  WidgetTester tester, {
  required Habit habit,
  required bool isCompleted,
  int streakDays = 0,
  VoidCallback? onComplete,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: HabitCard(
          habit: habit,
          isCompleted: isCompleted,
          streakDays: streakDays,
          onComplete: onComplete,
        ),
      ),
    ),
  );
}

void main() {
  group('HabitCard', () {
    testWidgets('should display habit title', (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: false);

      expect(find.text('読書 30分'), findsOneWidget);
    });

    testWidgets('should display habit points', (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: false);

      expect(find.text('30pt'), findsOneWidget);
    });

    testWidgets('should display "毎日" for daily frequency', (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: false);

      expect(find.text('毎日'), findsOneWidget);
    });

    testWidgets('should display "週N回" for weekly frequency', (tester) async {
      final weeklyHabit = Habit(
        id: 2,
        title: 'ジム',
        points: 50,
        frequencyType: FrequencyType.weekly,
        frequencyValue: 3,
        createdAt: DateTime(2024),
      );

      await pumpHabitCard(tester, habit: weeklyHabit, isCompleted: false);

      expect(find.text('週3回'), findsOneWidget);
    });

    testWidgets('should show HabitStreakIndicator when streakDays > 0',
        (tester) async {
      await pumpHabitCard(
        tester,
        habit: _baseHabit,
        isCompleted: false,
        streakDays: 7,
      );

      expect(find.byType(HabitStreakIndicator), findsOneWidget);
    });

    testWidgets('should not show HabitStreakIndicator when streakDays == 0',
        (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: false);

      expect(find.byType(HabitStreakIndicator), findsNothing);
    });

    testWidgets('should display "未達成" when isCompleted is false',
        (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: false);

      expect(find.text('未達成'), findsOneWidget);
      expect(find.text('今日達成済み'), findsNothing);
    });

    testWidgets('should display "今日達成済み" when isCompleted is true',
        (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: true);

      expect(find.text('今日達成済み'), findsOneWidget);
      expect(find.text('未達成'), findsNothing);
    });

    testWidgets(
        'should call onComplete callback when completion button is tapped',
        (tester) async {
      var callCount = 0;

      await pumpHabitCard(
        tester,
        habit: _baseHabit,
        isCompleted: false,
        onComplete: () => callCount++,
      );

      await tester.tap(find.byType(Button));
      await tester.pump();

      expect(callCount, equals(1));
    });

    testWidgets(
        'should display checkCircleFill icon when isCompleted is true',
        (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: true);

      expect(find.byIcon(BootstrapIcons.checkCircleFill), findsOneWidget);
    });

    testWidgets(
        'should not display Button and should display circle icon when isCompleted is false and onComplete is null',
        (tester) async {
      await pumpHabitCard(tester, habit: _baseHabit, isCompleted: false);

      expect(find.byType(Button), findsNothing);
      expect(find.byIcon(BootstrapIcons.circle), findsOneWidget);
    });
  });
}
