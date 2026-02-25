import 'package:hobica/core/database/providers/database_provider.dart';
import 'package:hobica/features/reward/data/datasources/reward_local_datasource.dart';
import 'package:hobica/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';
// クロスフィーチャー依存: reward交換後にwallet残高を減算する（アプリ設計上の意図的な依存）
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reward_list_provider.g.dart';

@riverpod
RewardLocalDataSource rewardLocalDataSource(RewardLocalDataSourceRef ref) {
  return RewardLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
RewardRepository rewardRepository(RewardRepositoryRef ref) {
  return RewardRepositoryImpl(ref.watch(rewardLocalDataSourceProvider));
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
      success: (redemption) async {
        ref.invalidateSelf();
        final walletResult = await ref
            .read(walletRepositoryProvider)
            .subtractPoints(redemption.pointsSpent);
        walletResult.when(success: (_) {}, failure: (error) => throw error);
        ref.invalidate(walletBalanceProvider);
        return redemption;
      },
      failure: (error) => throw error,
    );
  }
}
