import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/history/presentation/widgets/point_history_item.dart';
import 'package:hobica/features/history/presentation/widgets/point_history_list.dart';
import 'package:hobica/mocks/history_repository_provider.dart';
import 'package:hobica/mocks/mock_history_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _sampleLogs = [
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

Future<void> pumpPointHistoryList(
  WidgetTester tester, {
  required List<Override> overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: ShadcnApp(
        theme: _testTheme,
        home: const Scaffold(
          child: PointHistoryList(),
        ),
      ),
    ),
  );
}

void main() {
  group('PointHistoryList', () {
    testWidgets('データありの場合、PointHistoryItem が表示される', (tester) async {
      await pumpPointHistoryList(
        tester,
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(habitLogs: _sampleLogs),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(PointHistoryItem), findsNWidgets(2));
    });

    testWidgets('空リストの場合、EmptyView が表示される', (tester) async {
      await pumpPointHistoryList(
        tester,
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(habitLogs: []),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('ポイント獲得履歴はありません'), findsOneWidget);
    });

    testWidgets('ローディング中は LoadingIndicator が表示される', (tester) async {
      await pumpPointHistoryList(
        tester,
        overrides: [
          pointHistoryProvider.overrideWith(() => _NeverResolvingPointHistory()),
        ],
      );
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('エラー時は ErrorView が表示される', (tester) async {
      await pumpPointHistoryList(
        tester,
        overrides: [
          pointHistoryProvider.overrideWith(
            () => _ThrowingPointHistory(),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('ポイント履歴の取得に失敗しました'), findsOneWidget);
    });
  });
}

class _ThrowingPointHistory extends PointHistory {
  @override
  Future<List<HabitLog>> build() async {
    throw Exception('fetch error');
  }
}

class _NeverResolvingPointHistory extends PointHistory {
  @override
  Future<List<HabitLog>> build() {
    return Completer<List<HabitLog>>().future;
  }
}
