import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/database/providers/database_provider.dart';
import 'package:hobica/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_provider.g.dart';

@riverpod
WalletRepository walletRepository(WalletRepositoryRef ref) {
  return WalletRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
class WalletBalance extends _$WalletBalance {
  @override
  Future<Wallet> build() async {
    final repository = ref.watch(walletRepositoryProvider);
    return repository.getWallet();
  }
}
