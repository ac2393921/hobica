import 'package:drift/drift.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  const RewardRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Reward>> fetchAllRewards() async {
    final rows = await (
      _db.select(_db.rewards)..where((t) => t.isActive.equals(true))
    ).get();
    return rows.map(_rowToReward).toList();
  }

  @override
  Future<Reward?> fetchRewardById(int id) async {
    final row = await (
      _db.select(_db.rewards)
        ..where((t) => t.id.equals(id) & t.isActive.equals(true))
    ).getSingleOrNull();
    return row == null ? null : _rowToReward(row);
  }

  @override
  Future<Result<Reward, AppError>> createReward({
    required String title,
    required int targetPoints,
    String? imageUri,
    RewardCategory? category,
    String? memo,
  }) async {
    final row = await _db.into(_db.rewards).insertReturning(
          RewardsCompanion.insert(
            title: title,
            targetPoints: targetPoints,
            imageUri: Value(imageUri),
            category: Value(category?.name),
            memo: Value(memo),
            createdAt: DateTime.now(),
          ),
        );
    return Result.success(_rowToReward(row));
  }

  @override
  Future<Result<Reward, AppError>> updateReward(Reward reward) async {
    final count = await (
      _db.update(_db.rewards)
        ..where((t) => t.id.equals(reward.id) & t.isActive.equals(true))
    ).write(
      RewardsCompanion(
        title: Value(reward.title),
        imageUri: Value(reward.imageUri),
        targetPoints: Value(reward.targetPoints),
        category: Value(reward.category?.name),
        memo: Value(reward.memo),
      ),
    );
    if (count == 0) {
      return Result.failure(
        AppError.notFound('ご褒美が見つかりません（id: ${reward.id}）'),
      );
    }
    return Result.success(reward);
  }

  @override
  Future<Result<void, AppError>> deleteReward(int id) async {
    final count = await (
      _db.update(_db.rewards)
        ..where((t) => t.id.equals(id) & t.isActive.equals(true))
    ).write(const RewardsCompanion(isActive: Value(false)));
    if (count == 0) {
      return Result.failure(
        AppError.notFound('ご褒美が見つかりません（id: $id）'),
      );
    }
    return const Result.success(null);
  }

  @override
  Future<Result<RewardRedemption, AppError>> redeemReward(
    int rewardId,
    int currentPoints,
  ) async {
    final reward = await (
      _db.select(_db.rewards)
        ..where((t) => t.id.equals(rewardId) & t.isActive.equals(true))
    ).getSingleOrNull();
    if (reward == null) {
      return Result.failure(
        AppError.notFound('ご褒美が見つかりません（id: $rewardId）'),
      );
    }

    if (currentPoints < reward.targetPoints) {
      return Result.failure(
        AppError.insufficientPoints(
          'ポイントが不足しています: 必要 ${reward.targetPoints}, 所持 $currentPoints',
        ),
      );
    }

    final row = await _db.into(_db.rewardRedemptions).insertReturning(
          RewardRedemptionsCompanion.insert(
            rewardId: rewardId,
            pointsSpent: reward.targetPoints,
            redeemedAt: DateTime.now(),
          ),
        );
    return Result.success(_rowToRedemption(row));
  }

  Reward _rowToReward(RewardRow row) {
    return Reward(
      id: row.id,
      title: row.title,
      imageUri: row.imageUri,
      targetPoints: row.targetPoints,
      category: row.category == null
          ? null
          : RewardCategory.values.byName(row.category!),
      memo: row.memo,
      createdAt: row.createdAt,
      isActive: row.isActive,
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
