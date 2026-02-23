import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

class MockHistoryRepository implements HistoryRepository {
  MockHistoryRepository({
    List<HabitLog>? habitLogs,
    List<RewardRedemption>? redemptions,
  })  : _habitLogs = habitLogs ?? [],
        _redemptions = redemptions ?? [];

  final List<HabitLog> _habitLogs;
  final List<RewardRedemption> _redemptions;

  @override
  Future<List<HabitLog>> fetchHabitLogs() async =>
      List.unmodifiable(_habitLogs);

  @override
  Future<List<RewardRedemption>> fetchRedemptions() async =>
      List.unmodifiable(_redemptions);
}
