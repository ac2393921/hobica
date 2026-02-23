import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/presentation/pages/habit_detail_page.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_completion_calendar.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

/// MockHabitRepository を habitRepositoryProvider にオーバーライドして
/// HabitDetailPage をポンプするヘルパー関数。
Future<void> pumpHabitDetailPage(
  WidgetTester tester, {
  int habitId = 1,
  MockHabitRepository? mockRepo,
}) async {
  final repo = mockRepo ?? MockHabitRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        habitRepositoryProvider.overrideWithValue(repo),
      ],
      child: ShadcnApp(
        theme: _testTheme,
        home: Scaffold(
          child: HabitDetailPage(habitId: habitId),
        ),
      ),
    ),
  );
}

void main() {
  group('HabitDetailPage', () {
    testWidgets('ローディング中は LoadingIndicator を表示する', (tester) async {
      await pumpHabitDetailPage(tester);

      // pump 直後（非同期完了前）はローディング中
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('習慣のタイトルを表示する', (tester) async {
      await pumpHabitDetailPage(tester);
      await tester.pumpAndSettle();

      // Habit ID 1 のタイトル '読書 30分' が AppBar または本文に表示される
      expect(find.text('読書 30分'), findsAtLeastNWidgets(1));
    });

    testWidgets('習慣の頻度とポイントを表示する', (tester) async {
      await pumpHabitDetailPage(tester);
      await tester.pumpAndSettle();

      // 毎日（daily）の場合は「毎日」と表示される
      expect(find.text('毎日'), findsOneWidget);
      // ポイント表示
      expect(find.text('30pt'), findsOneWidget);
    });

    testWidgets('HabitCompletionCalendar を表示する', (tester) async {
      await pumpHabitDetailPage(tester);
      await tester.pumpAndSettle();

      expect(find.byType(HabitCompletionCalendar), findsOneWidget);
    });

    testWidgets('remindTime が設定されている場合はリマインド時刻を表示する', (tester) async {
      // Habit ID 1 には remindTime: DateTime(2026, 2, 1, 8) が設定されている
      await pumpHabitDetailPage(tester);
      await tester.pumpAndSettle();

      // リマインドセクションが表示される
      expect(find.byIcon(BootstrapIcons.alarm), findsOneWidget);
      expect(find.textContaining('リマインド: 08:00'), findsOneWidget);
    });

    testWidgets('remindTime が null の場合はリマインドセクションを表示しない', (tester) async {
      // Habit ID 2 (ランニング) には remindTime がない
      await pumpHabitDetailPage(tester, habitId: 2);
      await tester.pumpAndSettle();

      expect(find.byIcon(BootstrapIcons.alarm), findsNothing);
    });

    testWidgets('削除ボタンをタップすると確認ダイアログを表示する', (tester) async {
      await pumpHabitDetailPage(tester);
      await tester.pumpAndSettle();

      // 削除ボタン（Icons.delete）をタップ
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // 確認ダイアログが表示される
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('習慣を削除'), findsOneWidget);
      expect(find.text('キャンセル'), findsOneWidget);
      expect(find.text('削除'), findsAtLeastNWidgets(1));
    });

    testWidgets('存在しない習慣IDの場合はエラーメッセージを表示する', (tester) async {
      await pumpHabitDetailPage(tester, habitId: 9999);
      await tester.pumpAndSettle();

      expect(find.text('習慣が見つかりません'), findsOneWidget);
    });
  });
}
