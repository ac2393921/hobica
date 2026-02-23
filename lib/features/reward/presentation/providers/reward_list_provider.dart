import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/mocks/reward_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reward_list_provider.g.dart';

@riverpod
class RewardList extends _$RewardList {
  @override
  Future<List<Reward>> build() async {
    return ref.watch(rewardRepositoryProvider).fetchAllRewards();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
