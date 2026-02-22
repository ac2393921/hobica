import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';

abstract class WalletRepository {
  Future<Wallet> getWallet();
  Future<Wallet> addPoints(int points);
  Future<Result<Wallet, AppError>> subtractPoints(int points);
}
