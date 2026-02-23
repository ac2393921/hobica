import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_streak_indicator.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  final testTheme = ThemeData(
    colorScheme: ColorSchemes.slate(ThemeMode.light),
    radius: 0.5,
  );

  group('HabitStreakIndicator', () {
    testWidgets('should display streak days text', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: HabitStreakIndicator(streakDays: 7),
          ),
        ),
      );

      expect(find.text('7日連続'), findsOneWidget);
    });

    testWidgets('should display fire icon', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: HabitStreakIndicator(streakDays: 7),
          ),
        ),
      );

      expect(find.byIcon(BootstrapIcons.fire), findsOneWidget);
    });

    testWidgets('should reflect 1 day streak correctly', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: HabitStreakIndicator(streakDays: 1),
          ),
        ),
      );

      expect(find.text('1日連続'), findsOneWidget);
    });

    testWidgets('should reflect 30 day streak correctly', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: HabitStreakIndicator(streakDays: 30),
          ),
        ),
      );

      expect(find.text('30日連続'), findsOneWidget);
    });
  });
}
