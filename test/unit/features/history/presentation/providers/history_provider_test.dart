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
  group('HistoryHabitLogsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(
              habitLogs: mockHabitLogs.toList(),
              redemptions: mockRedemptions.toList(),
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は AsyncLoading', () {
      final state = container.read(historyHabitLogsProvider);
      expect(state, isA<AsyncLoading<List<HabitLog>>>());
    });

    test('fetchHabitLogs が返すリストを正しく公開する', () async {
      final result = await container.read(historyHabitLogsProvider.future);
      expect(result, hasLength(2));
      expect(result[0].id, 1);
      expect(result[1].id, 2);
    });

    test('refresh() 後もデータが一貫している', () async {
      await container.read(historyHabitLogsProvider.future);
      expect(container.read(historyHabitLogsProvider).value, hasLength(2));

      // MockHistoryRepository はイミュータブルなため、refresh 後も同じデータが返る
      final notifier = container.read(historyHabitLogsProvider.notifier);
      await notifier.refresh();

      expect(container.read(historyHabitLogsProvider).value, hasLength(2));
    });

    test('HistoryRepository を override して任意の実装を注入できる', () async {
      final customContainer = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => _AlwaysEmptyHistoryRepository(),
          ),
        ],
      );
      addTearDown(customContainer.dispose);

      final result =
          await customContainer.read(historyHabitLogsProvider.future);
      expect(result, isEmpty);
    });
  });

  group('HistoryRedemptionsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => MockHistoryRepository(
              habitLogs: mockHabitLogs.toList(),
              redemptions: mockRedemptions.toList(),
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は AsyncLoading', () {
      final state = container.read(historyRedemptionsProvider);
      expect(state, isA<AsyncLoading<List<RewardRedemption>>>());
    });

    test('fetchRedemptions が返すリストを正しく公開する', () async {
      final result = await container.read(historyRedemptionsProvider.future);
      expect(result, hasLength(1));
      expect(result[0].id, 1);
    });

    test('refresh() 後もデータが一貫している', () async {
      await container.read(historyRedemptionsProvider.future);
      expect(container.read(historyRedemptionsProvider).value, hasLength(1));

      // MockHistoryRepository はイミュータブルなため、refresh 後も同じデータが返る
      final notifier = container.read(historyRedemptionsProvider.notifier);
      await notifier.refresh();

      expect(container.read(historyRedemptionsProvider).value, hasLength(1));
    });

    test('HistoryRepository を override して任意の実装を注入できる', () async {
      final customContainer = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWith(
            (_) => _AlwaysEmptyHistoryRepository(),
          ),
        ],
      );
      addTearDown(customContainer.dispose);

      final result =
          await customContainer.read(historyRedemptionsProvider.future);
      expect(result, isEmpty);
    });
  });
}

/// テスト用：常に空リストを返すリポジトリ
class _AlwaysEmptyHistoryRepository implements HistoryRepository {
  @override
  Future<List<HabitLog>> fetchHabitLogs() async => [];

  @override
  Future<List<RewardRedemption>> fetchRedemptions() async => [];
}
