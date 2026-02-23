import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';

class MockWalletRepository implements WalletRepository {
  Wallet _wallet = Wallet(id: 1, updatedAt: DateTime.now());

  @override
  Future<Wallet> getWallet() async => _wallet;

  @override
  Future<Wallet> addPoints(int points) async {
    _wallet = _wallet.copyWith(
      currentPoints: _wallet.currentPoints + points,
      updatedAt: DateTime.now(),
    );
    return _wallet;
  }

  @override
  Future<Result<Wallet, AppError>> subtractPoints(int points) async {
    if (_wallet.currentPoints < points) {
      return Result.failure(
        AppError.insufficientPoints(
          'Insufficient points: need $points, have ${_wallet.currentPoints}',
        ),
      );
    }
    _wallet = _wallet.copyWith(
      currentPoints: _wallet.currentPoints - points,
      updatedAt: DateTime.now(),
    );
    return Result.success(_wallet);
  }
}
