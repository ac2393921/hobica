import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

class _FakeHistoryRepository implements HistoryRepository {
  @override
  Future<List<HabitLog>> fetchHabitLogs({int? limit, int? offset}) async =>
      const [];

  @override
  Future<List<RewardRedemption>> fetchRedemptions({
    int? limit,
    int? offset,
  }) async =>
      const [];
}

void main() {
  group('HistoryRepository インターフェースコントラクト', () {
    late HistoryRepository repository;

    setUp(() => repository = _FakeHistoryRepository());

    test('fetchHabitLogs は List<HabitLog> を返す', () async {
      final result = await repository.fetchHabitLogs();
      expect(result, isA<List<HabitLog>>());
    });

    test('fetchHabitLogs は limit/offset を受け付ける', () async {
      final result = await repository.fetchHabitLogs(limit: 10, offset: 0);
      expect(result, isA<List<HabitLog>>());
    });

    test('fetchRedemptions は List<RewardRedemption> を返す', () async {
      final result = await repository.fetchRedemptions();
      expect(result, isA<List<RewardRedemption>>());
    });

    test('fetchRedemptions は limit/offset を受け付ける', () async {
      final result = await repository.fetchRedemptions(limit: 5, offset: 10);
      expect(result, isA<List<RewardRedemption>>());
    });
  });
}
