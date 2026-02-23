import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_provider.g.dart';

@riverpod
WalletRepository walletRepository(Ref ref) {
  return MockWalletRepository();
}

@riverpod
class WalletNotifier extends _$WalletNotifier {
  @override
  Future<Wallet> build() async {
    final repository = ref.watch(walletRepositoryProvider);
    return repository.getWallet();
  }

  Future<void> addPoints(int points) async {
    final repository = ref.read(walletRepositoryProvider);
    final wallet = await repository.addPoints(points);
    state = AsyncValue.data(wallet);
  }

  Future<Result<Wallet, AppError>> subtractPoints(int points) async {
    final repository = ref.read(walletRepositoryProvider);
    final result = await repository.subtractPoints(points);
    if (result is Success<Wallet, AppError>) {
      state = AsyncValue.data(result.value);
    }
    return result;
  }
}
