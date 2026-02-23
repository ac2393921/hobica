import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

// データ書き込みは HabitRepository・RewardRepository が担当する。
abstract interface class HistoryRepository {
  Future<List<HabitLog>> fetchHabitLogs();

  Future<List<RewardRedemption>> fetchRedemptions();
}
