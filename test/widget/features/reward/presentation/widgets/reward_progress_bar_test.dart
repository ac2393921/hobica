import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_progress_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> pumpRewardProgressBar(
  WidgetTester tester, {
  required int currentPoints,
  required int targetPoints,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: RewardProgressBar(
          currentPoints: currentPoints,
          targetPoints: targetPoints,
        ),
      ),
    ),
  );
}

void main() {
  group('RewardProgressBar', () {
    testWidgets('should display Progress widget', (tester) async {
      await pumpRewardProgressBar(
        tester,
        currentPoints: 150,
        targetPoints: 200,
      );

      expect(find.byType(Progress), findsOneWidget);
    });

    testWidgets('should display progress text', (tester) async {
      await pumpRewardProgressBar(
        tester,
        currentPoints: 150,
        targetPoints: 200,
      );

      expect(find.text('150/200pt'), findsOneWidget);
    });

    testWidgets('should display remaining points text when not unlocked',
        (tester) async {
      await pumpRewardProgressBar(
        tester,
        currentPoints: 150,
        targetPoints: 200,
      );

      expect(find.text('あと50pt'), findsOneWidget);
    });

    testWidgets('should display "解禁！" when currentPoints == targetPoints',
        (tester) async {
      await pumpRewardProgressBar(
        tester,
        currentPoints: 200,
        targetPoints: 200,
      );

      expect(find.text('解禁！'), findsOneWidget);
    });

    testWidgets('should display "解禁！" when currentPoints > targetPoints',
        (tester) async {
      await pumpRewardProgressBar(
        tester,
        currentPoints: 250,
        targetPoints: 200,
      );

      expect(find.text('解禁！'), findsOneWidget);
    });
  });
}
