import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/monetization/domain/models/premium_status.dart';
import 'package:hobica/mocks/mock_purchase_repository.dart';

void main() {
  late MockPurchaseRepository repository;

  setUp(() {
    repository = MockPurchaseRepository();
  });

  group('MockPurchaseRepository', () {
    group('getPremiumStatus', () {
      test('returns non-premium status initially', () async {
        final status = await repository.getPremiumStatus();

        expect(status.isPremium, false);
        expect(status.purchaseToken, isNull);
        expect(status.id, 1);
      });
    });

    group('purchasePremium', () {
      test('returns success with premium status', () async {
        final result = await repository.purchasePremium();

        expect(result, isA<Success<PremiumStatus, AppError>>());
        final status = (result as Success<PremiumStatus, AppError>).value;
        expect(status.isPremium, true);
        expect(status.purchaseToken, isNotNull);
      });

      test('persists premium status in subsequent getPremiumStatus', () async {
        await repository.purchasePremium();

        final status = await repository.getPremiumStatus();
        expect(status.isPremium, true);
        expect(status.purchaseToken, isNotNull);
      });
    });

    group('restorePurchase', () {
      test('returns failure when no prior purchase exists', () async {
        final result = await repository.restorePurchase();

        expect(result, isA<Failure<PremiumStatus, AppError>>());
        expect(
          (result as Failure<PremiumStatus, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('returns success after purchasePremium', () async {
        await repository.purchasePremium();

        final result = await repository.restorePurchase();

        expect(result, isA<Success<PremiumStatus, AppError>>());
        final status = (result as Success<PremiumStatus, AppError>).value;
        expect(status.isPremium, true);
      });

      test('persists restored status in subsequent getPremiumStatus', () async {
        await repository.purchasePremium();
        await repository.restorePurchase();

        final status = await repository.getPremiumStatus();
        expect(status.isPremium, true);
      });
    });
  });
}
