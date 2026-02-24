import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/monetization/domain/models/premium_status.dart';
import 'package:hobica/features/monetization/domain/repositories/purchase_repository.dart';

class MockPurchaseRepository implements PurchaseRepository {
  PremiumStatus _status = PremiumStatus(id: 1, updatedAt: DateTime.now());

  @override
  Future<PremiumStatus> getPremiumStatus() async => _status;

  @override
  Future<Result<PremiumStatus, AppError>> purchasePremium() async {
    _status = _status.copyWith(
      isPremium: true,
      purchaseToken: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
      updatedAt: DateTime.now(),
    );
    return Result.success(_status);
  }

  @override
  Future<Result<PremiumStatus, AppError>> restorePurchase() async {
    if (_status.purchaseToken == null) {
      return const Result.failure(
        AppError.notFound('No purchase to restore'),
      );
    }
    _status = _status.copyWith(
      isPremium: true,
      updatedAt: DateTime.now(),
    );
    return Result.success(_status);
  }
}
