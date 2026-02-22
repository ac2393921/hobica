import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

abstract class RewardRepository {
  Future<List<Reward>> fetchAllRewards();
  Future<Reward?> fetchRewardById(int id);
  Future<Reward> createReward({
    required String title,
    required int targetPoints,
    String? imageUri,
    RewardCategory? category,
    String? memo,
  });
  Future<Reward> updateReward(Reward reward);
  Future<void> deleteReward(int id);
  Future<Result<RewardRedemption, AppError>> redeemReward(int rewardId);
}
