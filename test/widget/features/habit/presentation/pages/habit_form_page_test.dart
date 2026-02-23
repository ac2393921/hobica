import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/pages/habit_form_page.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _testHabit = Habit(
  id: 1,
  title: '読書 30分',
  points: 30,
  frequencyType: FrequencyType.daily,
  frequencyValue: 1,
  createdAt: DateTime(2024),
);

/// MockHabitRepository を habitRepositoryProvider にオーバーライドして
/// HabitFormPage をポンプするヘルパー関数。
Future<void> pumpHabitFormPage(
  WidgetTester tester, {
  Habit? initialHabit,
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
          child: HabitFormPage(initialHabit: initialHabit),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('HabitFormPage', () {
    group('作成モード（initialHabit = null）', () {
      testWidgets('タイトル「習慣を作成」が表示される', (tester) async {
        await pumpHabitFormPage(tester);

        expect(find.text('習慣を作成'), findsOneWidget);
      });

      testWidgets('タイトルフィールドが空の状態でレンダリングされる', (tester) async {
        await pumpHabitFormPage(tester);

        // タイトル入力フィールドが存在する
        expect(find.byType(TextField), findsAtLeastNWidgets(1));
      });

      testWidgets('削除ボタンが表示されない', (tester) async {
        await pumpHabitFormPage(tester);

        // 削除ボタンは編集モード限定
        expect(find.text('削除'), findsNothing);
      });

      testWidgets('保存ボタン（「作成」）が表示される', (tester) async {
        await pumpHabitFormPage(tester);

        expect(find.text('作成'), findsOneWidget);
      });

      testWidgets('頻度セクションに「毎日」「週次」ボタンが表示される', (tester) async {
        await pumpHabitFormPage(tester);

        expect(find.text('毎日'), findsOneWidget);
        expect(find.text('週次'), findsOneWidget);
      });
    });

    group('編集モード（initialHabit != null）', () {
      testWidgets('タイトル「習慣を編集」が表示される', (tester) async {
        await pumpHabitFormPage(tester, initialHabit: _testHabit);

        expect(find.text('習慣を編集'), findsOneWidget);
      });

      testWidgets('既存データ（タイトル）がフィールドに表示される', (tester) async {
        await pumpHabitFormPage(tester, initialHabit: _testHabit);

        // タイトルフィールドに既存のタイトルが入力されている
        expect(find.text('読書 30分'), findsAtLeastNWidgets(1));
      });

      testWidgets('削除ボタンが表示される', (tester) async {
        await pumpHabitFormPage(tester, initialHabit: _testHabit);

        expect(find.text('削除'), findsOneWidget);
      });

      testWidgets('保存ボタン（「保存」）が表示される', (tester) async {
        await pumpHabitFormPage(tester, initialHabit: _testHabit);

        expect(find.text('保存'), findsOneWidget);
      });

      testWidgets('削除ボタンをタップすると確認ダイアログが表示される', (tester) async {
        await pumpHabitFormPage(tester, initialHabit: _testHabit);

        await tester.tap(find.text('削除'));
        await tester.pumpAndSettle();

        // 確認ダイアログが表示される
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('習慣を削除'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);
      });
    });

    group('フォームバリデーション', () {
      testWidgets('タイトルを入力して保存ボタンをタップするとエラーなく動作する', (tester) async {
        await pumpHabitFormPage(tester);

        // タイトルを入力
        await tester.enterText(find.byType(TextField).first, 'テスト習慣');
        await tester.pump();

        // 作成ボタンをタップ（バリデーションエラーなし）
        await tester.tap(find.text('作成'));
        await tester.pumpAndSettle();

        // エラーが表示されないことを確認
        expect(find.text('エラー'), findsNothing);
      });
    });
  });
}
