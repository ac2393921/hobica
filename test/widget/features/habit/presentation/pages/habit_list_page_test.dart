import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/presentation/pages/habit_list_page.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_card.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

/// MockHabitRepository を habitRepositoryProvider にオーバーライドして
/// HabitListPage をポンプするヘルパー関数。
Future<void> pumpHabitListPage(
  WidgetTester tester, {
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
        home: const Scaffold(child: HabitListPage()),
      ),
    ),
  );
}

void main() {
  group('HabitListPage', () {
    testWidgets('ローディング中は LoadingIndicator を表示する', (tester) async {
      await pumpHabitListPage(tester);

      // pump 直後（非同期完了前）はローディング中
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('習慣一覧を HabitCard で表示する', (tester) async {
      await pumpHabitListPage(tester);
      await tester.pumpAndSettle();

      // MockHabitRepository にはデフォルトで習慣が存在する
      expect(find.byType(HabitCard), findsAtLeastNWidgets(1));
      expect(find.text('読書 30分'), findsOneWidget);
    });

    testWidgets('習慣が0件の場合は EmptyView を表示する', (tester) async {
      // 空の MockHabitRepository を使用（習慣を全て削除済みの状態）
      final emptyRepo = MockHabitRepository();
      // 初期習慣を全て削除してから使う
      final habits = await emptyRepo.fetchAllHabits();
      for (final habit in habits) {
        await emptyRepo.deleteHabit(habit.id);
      }

      await pumpHabitListPage(tester, mockRepo: emptyRepo);
      await tester.pumpAndSettle();

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('習慣がありません'), findsOneWidget);
    });

    testWidgets('AppBar に追加ボタン（Icons.add）が表示される', (tester) async {
      await pumpHabitListPage(tester);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('完了ボタンをタップすると isCompleted が true になる', (tester) async {
      await pumpHabitListPage(tester);
      await tester.pumpAndSettle();

      // 完了ボタン（"達成"または "未達成" ボタン）をタップ
      // HabitCard の完了ボタンは Button ウィジェット
      final completeButton = find.byType(Button).first;
      await tester.tap(completeButton);
      await tester.pumpAndSettle();

      // 完了後は「今日達成済み」と表示される
      expect(find.text('今日達成済み'), findsAtLeastNWidgets(1));
    });

    testWidgets('習慣を長押しするとアクションダイアログが表示される', (tester) async {
      await pumpHabitListPage(tester);
      await tester.pumpAndSettle();

      // 最初の HabitCard を長押し
      final firstCard = find.byType(HabitCard).first;
      await tester.longPress(firstCard);
      await tester.pumpAndSettle();

      // AlertDialog が表示される
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('編集'), findsOneWidget);
      expect(find.text('削除'), findsOneWidget);
    });
  });
}
