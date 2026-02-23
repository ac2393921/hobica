import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

ProviderContainer _makeContainer() {
  return ProviderContainer(
    overrides: [
      walletRepositoryProvider.overrideWithValue(MockWalletRepository()),
    ],
  );
}

void main() {
  group('walletRepositoryProvider', () {
    test('provides a WalletRepository instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(walletRepositoryProvider);
      expect(repo, isA<WalletRepository>());
    });
  });

  group('WalletNotifier', () {
    group('build', () {
      test('loads initial wallet state via getWallet', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final state = await container.read(walletNotifierProvider.future);

        expect(state, isA<Wallet>());
        expect(state.currentPoints, 0);
        expect(state.id, 1);
      });
    });

    group('addPoints', () {
      test('updates state after adding points', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(walletNotifierProvider.future);
        await container.read(walletNotifierProvider.notifier).addPoints(50);

        final state = container.read(walletNotifierProvider).value!;
        expect(state.currentPoints, 50);
      });

      test('accumulates multiple addPoints calls', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(walletNotifierProvider.future);
        await container.read(walletNotifierProvider.notifier).addPoints(30);
        await container.read(walletNotifierProvider.notifier).addPoints(20);

        final state = container.read(walletNotifierProvider).value!;
        expect(state.currentPoints, 50);
      });
    });

    group('subtractPoints', () {
      test('returns Failure when points exceed current balance', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(walletNotifierProvider.future);
        final result = await container
            .read(walletNotifierProvider.notifier)
            .subtractPoints(10);

        expect(result, isA<Failure<Wallet, AppError>>());
        expect(
          (result as Failure<Wallet, AppError>).error,
          isA<InsufficientPointsError>(),
        );
      });

      test(
        'returns Success and updates state when sufficient points',
        () async {
          final container = _makeContainer();
          addTearDown(container.dispose);

          await container.read(walletNotifierProvider.future);
          await container.read(walletNotifierProvider.notifier).addPoints(100);
          final result = await container
              .read(walletNotifierProvider.notifier)
              .subtractPoints(60);

          expect(result, isA<Success<Wallet, AppError>>());

          final state = container.read(walletNotifierProvider).value!;
          expect(state.currentPoints, 40);
        },
      );

      test('does not update state on failure', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(walletNotifierProvider.future);
        await container
            .read(walletNotifierProvider.notifier)
            .subtractPoints(99);

        final state = container.read(walletNotifierProvider).value!;
        expect(state.currentPoints, 0);
      });
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
        overrides: [walletRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await mockRepo.addPoints(100);
      container.invalidate(walletBalanceProvider);

      final wallet = await container.read(walletBalanceProvider.future);
      expect(wallet.currentPoints, 100);
    });
  });
}
