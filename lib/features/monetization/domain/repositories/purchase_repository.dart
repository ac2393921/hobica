import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/monetization/domain/models/premium_status.dart';

abstract interface class PurchaseRepository {
  Future<PremiumStatus> getPremiumStatus();

  Future<Result<PremiumStatus, AppError>> purchasePremium();

  Future<Result<PremiumStatus, AppError>> restorePurchase();
}
