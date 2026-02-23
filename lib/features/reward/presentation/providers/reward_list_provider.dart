import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reward_list_provider.g.dart';

@riverpod
RewardRepository rewardRepository(RewardRepositoryRef ref) {
  return MockRewardRepository();
}

@riverpod
class RewardList extends _$RewardList {
  @override
  Future<List<Reward>> build() async {
    final repository = ref.watch(rewardRepositoryProvider);
    return repository.fetchAllRewards();
  }

  Future<RewardRedemption> redeemReward(int rewardId, int currentPoints) async {
    final repository = ref.read(rewardRepositoryProvider);
    final result = await repository.redeemReward(rewardId, currentPoints);
    return result.when(
      success: (redemption) {
        ref.invalidateSelf();
        return redemption;
      },
      failure: (error) => throw error,
    );
  }
}
