import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_progress_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> pumpProgressBar(
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
    testWidgets('shows "あと X pt" when currentPoints < targetPoints', (
      tester,
    ) async {
      await pumpProgressBar(tester, currentPoints: 100, targetPoints: 300);

      expect(find.text('あと 200 pt'), findsOneWidget);
    });

    testWidgets('shows "解禁！" when currentPoints == targetPoints', (
      tester,
    ) async {
      await pumpProgressBar(tester, currentPoints: 300, targetPoints: 300);

      expect(find.text('解禁！'), findsOneWidget);
    });

    testWidgets('shows "解禁！" when currentPoints > targetPoints', (
      tester,
    ) async {
      await pumpProgressBar(tester, currentPoints: 500, targetPoints: 300);

      expect(find.text('解禁！'), findsOneWidget);
    });

    testWidgets('shows LinearProgressIndicator', (tester) async {
      await pumpProgressBar(tester, currentPoints: 100, targetPoints: 300);

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('handles targetPoints=0 without division by zero', (
      tester,
    ) async {
      await pumpProgressBar(tester, currentPoints: 0, targetPoints: 0);

      expect(find.text('解禁！'), findsOneWidget);
    });
  });
}
