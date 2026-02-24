import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (_) => MockWalletRepository(),
);
