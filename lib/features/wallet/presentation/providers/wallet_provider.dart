import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/mocks/wallet_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_provider.g.dart';

@riverpod
class WalletBalance extends _$WalletBalance {
  @override
  Future<Wallet> build() async {
    return ref.watch(walletRepositoryProvider).getWallet();
  }
}
