import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/mock_history_repository.dart';

void main() {
  group('MockHistoryRepository', () {
    group('fetchHabitLogs', () {
      test('returns empty list when no logs injected', () async {
        final repository = MockHistoryRepository();
        final logs = await repository.fetchHabitLogs();
        expect(logs, isEmpty);
      });

      test('returns injected habitLogs', () async {
        final now = DateTime.now();
        final logs = [
          HabitLog(
            id: 1,
            habitId: 10,
            date: DateTime(now.year, now.month, now.day),
            points: 10,
            createdAt: now,
          ),
          HabitLog(
            id: 2,
            habitId: 20,
            date: DateTime(now.year, now.month, now.day - 1),
            points: 5,
            createdAt: now,
          ),
        ];
        final repository = MockHistoryRepository(habitLogs: logs);

        final result = await repository.fetchHabitLogs();
        expect(result.length, 2);
        expect(result.first.habitId, 10);
        expect(result.last.habitId, 20);
      });

      test('returned list is unmodifiable', () async {
        final now = DateTime.now();
        final repository = MockHistoryRepository();
        final logs = await repository.fetchHabitLogs();
        final extra = HabitLog(
          id: 99,
          habitId: 99,
          date: DateTime(now.year, now.month, now.day),
          points: 1,
          createdAt: now,
        );
        expect(() => logs.add(extra), throwsUnsupportedError);
      });
    });

    group('fetchRedemptions', () {
      test('returns empty list when no redemptions injected', () async {
        final repository = MockHistoryRepository();
        final result = await repository.fetchRedemptions();
        expect(result, isEmpty);
      });

      test('returns injected redemptions', () async {
        final now = DateTime.now();
        final redemptions = [
          RewardRedemption(
            id: 1,
            rewardId: 100,
            pointsSpent: 200,
            redeemedAt: now,
          ),
        ];
        final repository = MockHistoryRepository(redemptions: redemptions);

        final result = await repository.fetchRedemptions();
        expect(result.length, 1);
        expect(result.first.rewardId, 100);
        expect(result.first.pointsSpent, 200);
      });

      test('returned list is unmodifiable', () async {
        final now = DateTime.now();
        final repository = MockHistoryRepository();
        final redemptions = await repository.fetchRedemptions();
        final extra = RewardRedemption(
          id: 99,
          rewardId: 99,
          pointsSpent: 1,
          redeemedAt: now,
        );
        expect(() => redemptions.add(extra), throwsUnsupportedError);
      });
    });

    group('constructor', () {
      test('accepts both habitLogs and redemptions simultaneously', () async {
        final now = DateTime.now();
        final logs = [
          HabitLog(
            id: 1,
            habitId: 1,
            date: DateTime(now.year, now.month, now.day),
            points: 10,
            createdAt: now,
          ),
        ];
        final redemptions = [
          RewardRedemption(
            id: 1,
            rewardId: 1,
            pointsSpent: 100,
            redeemedAt: now,
          ),
        ];
        final repository = MockHistoryRepository(
          habitLogs: logs,
          redemptions: redemptions,
        );

        expect((await repository.fetchHabitLogs()).length, 1);
        expect((await repository.fetchRedemptions()).length, 1);
      });
    });
  });
}
