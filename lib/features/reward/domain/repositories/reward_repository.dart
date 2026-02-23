import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

abstract interface class RewardRepository {
  Future<List<Reward>> fetchAllRewards();

  Future<Reward?> fetchRewardById(int id);

  Future<Result<Reward, AppError>> createReward({
    required String title,
    required int targetPoints,
    String? imageUri,
    RewardCategory? category,
    String? memo,
  });

  Future<Result<Reward, AppError>> updateReward(Reward reward);

  Future<Result<void, AppError>> deleteReward(int id);

  // [currentPoints] を受け取ることで WalletRepository への依存を排除する。
  Future<Result<RewardRedemption, AppError>> redeemReward(
    int rewardId,
    int currentPoints,
  );
}
