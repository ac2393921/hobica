import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/monetization/domain/models/premium_status.dart';
import 'package:hobica/features/monetization/domain/repositories/purchase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchase_provider.g.dart';

@riverpod
PurchaseRepository purchaseRepository(PurchaseRepositoryRef ref) {
  throw UnimplementedError(
    'purchaseRepositoryProvider must be overridden in ProviderScope',
  );
}

@riverpod
class PurchaseNotifier extends _$PurchaseNotifier {
  @override
  Future<PremiumStatus> build() async {
    final repository = ref.watch(purchaseRepositoryProvider);
    return repository.getPremiumStatus();
  }

  Future<Result<void, AppError>> purchasePremium() async {
    final repository = ref.read(purchaseRepositoryProvider);
    final result = await repository.purchasePremium();
    return result.when(
      success: (status) {
        state = AsyncValue.data(status);
        return const Result<void, AppError>.success(null);
      },
      failure: Result.failure,
    );
  }

  Future<Result<void, AppError>> restorePurchase() async {
    final repository = ref.read(purchaseRepositoryProvider);
    final result = await repository.restorePurchase();
    return result.when(
      success: (status) {
        state = AsyncValue.data(status);
        return const Result<void, AppError>.success(null);
      },
      failure: Result.failure,
    );
  }
}
