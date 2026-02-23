import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';

class MockRewardRepository implements RewardRepository {
  MockRewardRepository()
      : _rewards = [
          Reward(
            id: 1,
            title: 'コーヒー',
            targetPoints: 100,
            category: RewardCategory.food,
            createdAt: DateTime(2024, 1, 1),
          ),
          Reward(
            id: 2,
            title: 'マッサージ',
            targetPoints: 500,
            category: RewardCategory.beauty,
            memo: '月1回の楽しみ',
            createdAt: DateTime(2024, 1, 2),
          ),
        ],
        _nextId = 3;

  final List<Reward> _rewards;
  int _nextId;

  @override
  Future<List<Reward>> fetchAllRewards() async => List.unmodifiable(_rewards);

  @override
  Future<Result<Reward, AppError>> createReward({
    required String title,
    String? imageUri,
    required int targetPoints,
    RewardCategory? category,
    String? memo,
  }) async {
    final reward = Reward(
      id: _nextId++,
      title: title,
      imageUri: imageUri,
      targetPoints: targetPoints,
      category: category,
      memo: memo,
      createdAt: DateTime.now(),
    );
    _rewards.add(reward);
    return Result.success(reward);
  }

  @override
  Future<Result<Reward, AppError>> updateReward({
    required int id,
    required String title,
    String? imageUri,
    required int targetPoints,
    RewardCategory? category,
    String? memo,
    required bool isActive,
  }) async {
    final index = _rewards.indexWhere((r) => r.id == id);
    if (index == -1) {
      return Result.failure(AppError.notFound('ご褒美が見つかりません'));
    }
    final updated = _rewards[index].copyWith(
      title: title,
      imageUri: imageUri,
      targetPoints: targetPoints,
      category: category,
      memo: memo,
      isActive: isActive,
    );
    _rewards[index] = updated;
    return Result.success(updated);
  }

  @override
  Future<Result<void, AppError>> deleteReward(int id) async {
    _rewards.removeWhere((r) => r.id == id);
    return const Result<void, AppError>.success(null);
  }

  @override
  Future<Result<RewardRedemption, AppError>> redeemReward(
    int id,
    int pointsSpent,
  ) async {
    final exists = _rewards.any((r) => r.id == id);
    if (!exists) {
      return Result.failure(AppError.notFound('ご褒美が見つかりません'));
    }
    final redemption = RewardRedemption(
      id: _nextId++,
      rewardId: id,
      pointsSpent: pointsSpent,
      redeemedAt: DateTime.now(),
    );
    return Result.success(redemption);
  }
}
