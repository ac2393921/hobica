import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';

class MockRewardRepository implements RewardRepository {
  List<Reward> _rewards = [];
  List<RewardRedemption> _redemptions = [];
  int _nextRewardId = 1;
  int _nextRedemptionId = 1;

  List<RewardRedemption> get redemptions => List.unmodifiable(_redemptions);

  @override
  Future<List<Reward>> fetchAllRewards() async => List.unmodifiable(_rewards);

  @override
  Future<Reward?> fetchRewardById(int id) async {
    return _rewards.where((r) => r.id == id).firstOrNull;
  }

  @override
  Future<Result<Reward, AppError>> createReward({
    required String title,
    required int targetPoints,
    String? imageUri,
    RewardCategory? category,
    String? memo,
  }) async {
    final reward = Reward(
      id: _nextRewardId++,
      title: title,
      targetPoints: targetPoints,
      imageUri: imageUri,
      category: category,
      memo: memo,
      createdAt: DateTime.now(),
    );
    _rewards = [..._rewards, reward];
    return Result.success(reward);
  }

  @override
  Future<Result<Reward, AppError>> updateReward(Reward reward) async {
    final index = _rewards.indexWhere((r) => r.id == reward.id);
    if (index == -1) {
      return Result.failure(
        AppError.notFound('Reward with id ${reward.id} not found'),
      );
    }
    final updated = [..._rewards];
    updated[index] = reward;
    _rewards = updated;
    return Result.success(reward);
  }

  @override
  Future<Result<void, AppError>> deleteReward(int id) async {
    final exists = _rewards.any((r) => r.id == id);
    if (!exists) {
      return Result.failure(AppError.notFound('Reward with id $id not found'));
    }
    _rewards = _rewards.where((r) => r.id != id).toList(growable: false);
    return const Result.success(null);
  }

  @override
  Future<Result<RewardRedemption, AppError>> redeemReward(
    int rewardId,
    int currentPoints,
  ) async {
    final reward = _rewards.where((r) => r.id == rewardId).firstOrNull;
    if (reward == null) {
      return Result.failure(
        AppError.notFound('Reward with id $rewardId not found'),
      );
    }

    if (currentPoints < reward.targetPoints) {
      return Result.failure(
        AppError.insufficientPoints(
          'Insufficient points: need ${reward.targetPoints}, have $currentPoints',
        ),
      );
    }

    final redemption = RewardRedemption(
      id: _nextRedemptionId++,
      rewardId: rewardId,
      pointsSpent: reward.targetPoints,
      redeemedAt: DateTime.now(),
    );
    _redemptions = [..._redemptions, redemption];
    return Result.success(redemption);
  }
}
