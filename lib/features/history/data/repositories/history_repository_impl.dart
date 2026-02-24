import 'package:drift/drift.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

// 書き込みは HabitRepository・RewardRepository が担当する。このクラスは読み取り専用。
class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<HabitLog>> fetchHabitLogs() async {
    final rows = await (
      _db.select(_db.habitLogs)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
    ).get();
    return rows.map(_rowToHabitLog).toList();
  }

  @override
  Future<List<RewardRedemption>> fetchRedemptions() async {
    final rows = await (
      _db.select(_db.rewardRedemptions)
        ..orderBy([(t) => OrderingTerm.desc(t.redeemedAt)])
    ).get();
    return rows.map(_rowToRedemption).toList();
  }

  HabitLog _rowToHabitLog(HabitLogRow row) {
    return HabitLog(
      id: row.id,
      habitId: row.habitId,
      date: row.date,
      points: row.points,
      createdAt: row.createdAt,
    );
  }

  RewardRedemption _rowToRedemption(RewardRedemptionRow row) {
    return RewardRedemption(
      id: row.id,
      rewardId: row.rewardId,
      pointsSpent: row.pointsSpent,
      redeemedAt: row.redeemedAt,
    );
  }
}
