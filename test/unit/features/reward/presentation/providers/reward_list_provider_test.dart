import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

ProviderContainer _makeContainer(
  MockRewardRepository repo, {
  MockWalletRepository? wallet,
}) {
  return ProviderContainer(
    overrides: [
      rewardRepositoryProvider.overrideWithValue(repo),
      walletRepositoryProvider.overrideWithValue(wallet ?? MockWalletRepository()),
    ],
  );
}

void main() {
  group('rewardRepositoryProvider', () {
    test('requires appDatabaseProvider override for default usage', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(rewardRepositoryProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('rewardListProvider', () {
    test('returns empty list initially', () async {
      final repo = MockRewardRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final rewards = await container.read(rewardListProvider.future);
      expect(rewards, isEmpty);
    });

    test('redeemReward succeeds with sufficient points', () async {
      final repo = MockRewardRepository();
      final mockWallet = MockWalletRepository();
      await mockWallet.addPoints(500);
      final container = _makeContainer(repo, wallet: mockWallet);
      addTearDown(container.dispose);

      await repo.createReward(title: 'ケーキ', targetPoints: 300);
      container.invalidate(rewardListProvider);

      final rewards = await container.read(rewardListProvider.future);
      final rewardId = rewards.first.id;

      final redemption = await container
          .read(rewardListProvider.notifier)
          .redeemReward(rewardId, 500);

      expect(redemption.rewardId, rewardId);
      expect(redemption.pointsSpent, 300);
    });

    test(
      'redeemReward throws InsufficientPointsError when points insufficient',
      () async {
        final repo = MockRewardRepository();
        final container = _makeContainer(repo);
        addTearDown(container.dispose);

        await repo.createReward(title: 'ケーキ', targetPoints: 300);
        container.invalidate(rewardListProvider);

        final rewards = await container.read(rewardListProvider.future);
        final rewardId = rewards.first.id;

        expect(
          () => container
              .read(rewardListProvider.notifier)
              .redeemReward(rewardId, 100),
          throwsA(isA<InsufficientPointsError>()),
        );
      },
    );
  });
}
