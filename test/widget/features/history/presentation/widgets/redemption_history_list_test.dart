import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/history/presentation/widgets/redemption_history_item.dart';
import 'package:hobica/features/history/presentation/widgets/redemption_history_list.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/history_repository_provider.dart';
import 'package:hobica/mocks/mock_history_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

final _sampleRedemptions = [
  RewardRedemption(
    id: 1,
    rewardId: 1,
    pointsSpent: 100,
    redeemedAt: DateTime(2026, 2, 1),
  ),
  RewardRedemption(
    id: 2,
    rewardId: 2,
    pointsSpent: 200,
    redeemedAt: DateTime(2026, 2, 5),
  ),
];

Future<void> pumpRedemptionHistoryList(
  WidgetTester tester, {
  required List<Override> overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: ShadcnApp(
        theme: _testTheme,
        home: const Scaffold(
          child: RedemptionHistoryList(),
        ),
      ),
    ),
  );
}

void main() {
  group('RedemptionHistoryList', () {
    testWidgets('データありの場合、RedemptionHistoryItem が表示される', (tester) async {
      await pumpRedemptionHistoryList(
        tester,
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(redemptions: _sampleRedemptions),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(RedemptionHistoryItem), findsNWidgets(2));
    });

    testWidgets('空リストの場合、EmptyView が表示される', (tester) async {
      await pumpRedemptionHistoryList(
        tester,
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(redemptions: []),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('交換履歴はありません'), findsOneWidget);
    });

    testWidgets('ローディング中は LoadingIndicator が表示される', (tester) async {
      await pumpRedemptionHistoryList(
        tester,
        overrides: [
          redemptionHistoryProvider.overrideWith(
            () => _NeverResolvingRedemptionHistory(),
          ),
        ],
      );
      await tester.pump();

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('エラー時は ErrorView が表示される', (tester) async {
      await pumpRedemptionHistoryList(
        tester,
        overrides: [
          redemptionHistoryProvider.overrideWith(
            () => _ThrowingRedemptionHistory(),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('交換履歴の取得に失敗しました'), findsOneWidget);
    });
  });
}

class _ThrowingRedemptionHistory extends RedemptionHistory {
  @override
  Future<List<RewardRedemption>> build() async {
    throw Exception('fetch error');
  }
}

class _NeverResolvingRedemptionHistory extends RedemptionHistory {
  @override
  Future<List<RewardRedemption>> build() {
    return Completer<List<RewardRedemption>>().future;
  }
}
