// history feature は独自のドメインモデルを持たない設計（DESIGN.md 準拠）。
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

abstract class HistoryRepository {
  Future<List<HabitLog>> fetchHabitLogs({int? limit, int? offset});
  Future<List<RewardRedemption>> fetchRedemptions({int? limit, int? offset});
}
