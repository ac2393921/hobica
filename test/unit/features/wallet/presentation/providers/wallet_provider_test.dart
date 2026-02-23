import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

void main() {
  group('walletRepositoryProvider', () {
    test('provides a WalletRepository instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(walletRepositoryProvider);
      expect(repo, isA<WalletRepository>());
    });
  });

  group('walletBalanceProvider', () {
    test('returns initial wallet with 0 points', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final wallet = await container.read(walletBalanceProvider.future);
      expect(wallet, isA<Wallet>());
      expect(wallet.currentPoints, 0);
    });

    test('reflects updated balance after repository addPoints', () async {
      final mockRepo = MockWalletRepository();
      final container = ProviderContainer(
        overrides: [
          walletRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await mockRepo.addPoints(100);
      container.invalidate(walletBalanceProvider);

      final wallet = await container.read(walletBalanceProvider.future);
      expect(wallet.currentPoints, 100);
    });
  });
}
