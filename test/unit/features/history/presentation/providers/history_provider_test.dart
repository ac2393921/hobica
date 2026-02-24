import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/fixtures.dart';
import 'package:hobica/mocks/history_repository_provider.dart';
import 'package:hobica/mocks/mock_history_repository.dart';

void main() {
  group('PointHistoryProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(habitLogs: mockHabitLogs),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は AsyncLoading', () {
      final state = container.read(pointHistoryProvider);
      expect(state, isA<AsyncLoading<List<HabitLog>>>());
    });

    test('fetchHabitLogs が返すリストを正しく公開する', () async {
      final result = await container.read(pointHistoryProvider.future);
      expect(result, hasLength(mockHabitLogs.length));
      expect(result.first.habitId, mockHabitLogs.first.habitId);
    });

    test('HistoryRepository を override して任意の実装を注入できる', () async {
      final customMock = _AlwaysEmptyHistoryRepository();
      final customContainer = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith((_) => customMock),
        ],
      );
      addTearDown(customContainer.dispose);

      final result = await customContainer.read(pointHistoryProvider.future);
      expect(result, isEmpty);
    });
  });

  group('RedemptionHistoryProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(redemptions: mockRedemptions),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は AsyncLoading', () {
      final state = container.read(redemptionHistoryProvider);
      expect(state, isA<AsyncLoading<List<RewardRedemption>>>());
    });

    test('fetchRedemptions が返すリストを正しく公開する', () async {
      final result = await container.read(redemptionHistoryProvider.future);
      expect(result, hasLength(mockRedemptions.length));
      expect(result.first.rewardId, mockRedemptions.first.rewardId);
    });

    test('HistoryRepository を override して任意の実装を注入できる', () async {
      final customMock = _AlwaysEmptyHistoryRepository();
      final customContainer = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith((_) => customMock),
        ],
      );
      addTearDown(customContainer.dispose);

      final result =
          await customContainer.read(redemptionHistoryProvider.future);
      expect(result, isEmpty);
    });
  });
}

class _AlwaysEmptyHistoryRepository implements HistoryRepository {
  @override
  Future<List<HabitLog>> fetchHabitLogs() async => [];

  @override
  Future<List<RewardRedemption>> fetchRedemptions() async => [];
}
