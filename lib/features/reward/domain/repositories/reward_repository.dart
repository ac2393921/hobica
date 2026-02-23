import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

abstract class RewardRepository {
  Future<List<Reward>> fetchAllRewards();

  Future<Result<Reward, AppError>> createReward({
    required String title,
    String? imageUri,
    required int targetPoints,
    RewardCategory? category,
    String? memo,
  });

  Future<Result<Reward, AppError>> updateReward({
    required int id,
    required String title,
    String? imageUri,
    required int targetPoints,
    RewardCategory? category,
    String? memo,
    required bool isActive,
  });

  Future<Result<void, AppError>> deleteReward(int id);

  Future<Result<RewardRedemption, AppError>> redeemReward(
    int id,
    int pointsSpent,
  );
}
