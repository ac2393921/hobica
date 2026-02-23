import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

class _FakeHistoryRepository implements HistoryRepository {
  @override
  Future<List<HabitLog>> fetchHabitLogs() async => const [];

  @override
  Future<List<RewardRedemption>> fetchRedemptions() async => const [];
}

void main() {
  group('HistoryRepository インターフェースコントラクト', () {
    late HistoryRepository repository;

    setUp(() => repository = _FakeHistoryRepository());

    test('fetchHabitLogs は List<HabitLog> を返す', () async {
      final result = await repository.fetchHabitLogs();
      expect(result, isA<List<HabitLog>>());
    });

    test('fetchRedemptions は List<RewardRedemption> を返す', () async {
      final result = await repository.fetchRedemptions();
      expect(result, isA<List<RewardRedemption>>());
    });
  });
}
