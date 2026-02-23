import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_provider.g.dart';

@riverpod
WalletRepository walletRepository(WalletRepositoryRef ref) {
  return MockWalletRepository();
}

@riverpod
class WalletBalance extends _$WalletBalance {
  @override
  Future<Wallet> build() async {
    final repository = ref.watch(walletRepositoryProvider);
    return repository.getWallet();
  }
}
