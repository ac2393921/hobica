import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';

class _FakeRewardRepository implements RewardRepository {
  // 有効な報酬IDのみ redeemReward が成功する（ID不正時の notFound エラーをテストするため）
  static const _validRewardId = 1;

  @override
  Future<List<Reward>> fetchAllRewards() async => const [];

  @override
  Future<Reward?> fetchRewardById(int id) async => null;

  @override
  Future<Reward> createReward({
    required String title,
    required int targetPoints,
    String? imageUri,
    RewardCategory? category,
    String? memo,
  }) async =>
      Reward(
        id: 1,
        title: title,
        targetPoints: targetPoints,
        imageUri: imageUri,
        category: category,
        memo: memo,
        createdAt: DateTime(2026, 2, 22),
        isActive: true,
      );

  @override
  Future<Reward> updateReward(Reward reward) async => reward;

  @override
  Future<void> deleteReward(int id) async {}

  @override
  Future<Result<RewardRedemption, AppError>> redeemReward(int rewardId) async {
    if (rewardId != _validRewardId) {
      return const Result.failure(AppError.notFound('報酬が見つかりません'));
    }
    return Result.success(RewardRedemption(
      id: 1,
      rewardId: rewardId,
      pointsSpent: 500,
      redeemedAt: DateTime(2026, 2, 22),
    ),);
  }
}

void main() {
  group('RewardRepository インターフェースコントラクト', () {
    late RewardRepository repository;

    setUp(() => repository = _FakeRewardRepository());

    test('fetchAllRewards は List<Reward> を返す', () async {
      final result = await repository.fetchAllRewards();
      expect(result, isA<List<Reward>>());
    });

    test('fetchRewardById は存在しないIDで null を返す', () async {
      final result = await repository.fetchRewardById(999);
      expect(result, isNull);
    });

    test('createReward は Reward を返す', () async {
      final result = await repository.createReward(
        title: 'ケーキ',
        targetPoints: 500,
      );
      expect(result, isA<Reward>());
      expect(result.title, 'ケーキ');
      expect(result.targetPoints, 500);
    });

    test('updateReward は更新後の Reward を返す', () async {
      final reward = Reward(
        id: 1,
        title: 'ケーキ',
        targetPoints: 500,
        createdAt: DateTime(2026, 2, 22),
        isActive: true,
      );
      final result = await repository.updateReward(reward);
      expect(result, isA<Reward>());
    });

    test('deleteReward は例外なく完了する', () async {
      await expectLater(repository.deleteReward(1), completes);
    });

    test('redeemReward は Result<RewardRedemption, AppError> を Success で返す', () async {
      final result = await repository.redeemReward(1);
      expect(result, isA<Result<RewardRedemption, AppError>>());
      result.when(
        success: (redemption) => expect(redemption.rewardId, 1),
        failure: (_) => fail('Success を期待したが Failure が返った'),
      );
    });

    test('redeemReward は存在しない ID で notFound エラーを返す', () async {
      final result = await repository.redeemReward(999);
      result.when(
        success: (_) => fail('Failure を期待したが Success が返った'),
        failure: (error) => expect(error, isA<NotFoundError>()),
      );
    });
  });
}
