import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/monetization/presentation/providers/purchase_provider.dart';
import 'package:hobica/mocks/mock_purchase_repository.dart';

ProviderContainer _makeContainer() {
  return ProviderContainer(
    overrides: [
      purchaseRepositoryProvider.overrideWithValue(MockPurchaseRepository()),
    ],
  );
}

void main() {
  group('purchaseRepositoryProvider', () {
    test('throws UnimplementedError by default', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(purchaseRepositoryProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('PurchaseNotifier', () {
    group('build', () {
      test('loads initial non-premium status', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final status = await container.read(purchaseNotifierProvider.future);

        expect(status.isPremium, false);
        expect(status.purchaseToken, isNull);
      });
    });

    group('purchasePremium', () {
      test('returns success and updates state to premium', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(purchaseNotifierProvider.future);

        final result = await container
            .read(purchaseNotifierProvider.notifier)
            .purchasePremium();

        expect(result, isA<Success<void, AppError>>());

        final status = container.read(purchaseNotifierProvider).value!;
        expect(status.isPremium, true);
        expect(status.purchaseToken, isNotNull);
      });
    });

    group('restorePurchase', () {
      test('returns failure when no prior purchase exists', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(purchaseNotifierProvider.future);

        final result = await container
            .read(purchaseNotifierProvider.notifier)
            .restorePurchase();

        expect(result, isA<Failure<void, AppError>>());
        expect(
          (result as Failure<void, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('returns success after purchasePremium', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(purchaseNotifierProvider.future);

        await container
            .read(purchaseNotifierProvider.notifier)
            .purchasePremium();

        final result = await container
            .read(purchaseNotifierProvider.notifier)
            .restorePurchase();

        expect(result, isA<Success<void, AppError>>());

        final status = container.read(purchaseNotifierProvider).value!;
        expect(status.isPremium, true);
      });
    });
  });
}
