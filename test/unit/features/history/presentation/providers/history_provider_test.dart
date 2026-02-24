import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/mock_history_repository.dart';

void main() {
  late ProviderContainer container;

  final testHabitLogs = [
    HabitLog(
      id: 1,
      habitId: 1,
      date: DateTime(2026, 2, 20),
      points: 30,
      createdAt: DateTime(2026, 2, 20),
    ),
  ];

  final testRedemptions = [
    RewardRedemption(
      id: 1,
      rewardId: 1,
      pointsSpent: 100,
      redeemedAt: DateTime(2026, 2, 1),
    ),
  ];

  setUp(() {
    container = ProviderContainer(
      overrides: [
        historyRepositoryProvider.overrideWithValue(
          MockHistoryRepository(
            habitLogs: testHabitLogs,
            redemptions: testRedemptions,
          ),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('historyRepositoryProvider', () {
    test('returns MockHistoryRepository with fixtures by default', () {
      final defaultContainer = ProviderContainer();
      addTearDown(defaultContainer.dispose);

      final repo = defaultContainer.read(historyRepositoryProvider);
      expect(repo, isA<MockHistoryRepository>());
    });
  });

  group('HistoryState', () {
    test('holds habitLogs and redemptions', () {
      const state = HistoryState(
        habitLogs: [],
        redemptions: [],
      );
      expect(state.habitLogs, isEmpty);
      expect(state.redemptions, isEmpty);
    });

    test('supports equality comparison', () {
      const state1 = HistoryState(habitLogs: [], redemptions: []);
      const state2 = HistoryState(habitLogs: [], redemptions: []);
      expect(state1, equals(state2));
    });
  });

  group('History notifier', () {
    test('build loads habitLogs and redemptions from repository', () async {
      final state = await container.read(historyProvider.future);

      expect(state.habitLogs, equals(testHabitLogs));
      expect(state.redemptions, equals(testRedemptions));
    });

    test('build returns empty lists when repository has no data', () async {
      final emptyContainer = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWithValue(
            MockHistoryRepository(),
          ),
        ],
      );
      addTearDown(emptyContainer.dispose);

      final state = await emptyContainer.read(historyProvider.future);

      expect(state.habitLogs, isEmpty);
      expect(state.redemptions, isEmpty);
    });

    test('historyProvider initial state is AsyncLoading', () {
      final asyncValue = container.read(historyProvider);
      expect(asyncValue, isA<AsyncLoading<HistoryState>>());
    });
  });
}
