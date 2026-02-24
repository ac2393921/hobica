import 'package:drift/drift.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._db);

  final AppDatabase _db;

  static const _walletId = 1;

  @override
  Future<Wallet> getWallet() async {
    await _db.into(_db.wallets).insert(
          WalletsCompanion(
            id: const Value(_walletId),
            currentPoints: const Value(0),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    final row = await (
      _db.select(_db.wallets)..where((t) => t.id.equals(_walletId))
    ).getSingle();
    return _rowToWallet(row);
  }

  @override
  Future<Wallet> addPoints(int points) async {
    final current = await getWallet();
    await (
      _db.update(_db.wallets)..where((t) => t.id.equals(_walletId))
    ).write(
      WalletsCompanion(
        currentPoints: Value(current.currentPoints + points),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final row = await (
      _db.select(_db.wallets)..where((t) => t.id.equals(_walletId))
    ).getSingle();
    return _rowToWallet(row);
  }

  @override
  Future<Result<Wallet, AppError>> subtractPoints(int points) async {
    final current = await getWallet();
    if (current.currentPoints < points) {
      return Result.failure(
        AppError.insufficientPoints(
          'ポイントが不足しています: 必要 $points, 所持 ${current.currentPoints}',
        ),
      );
    }
    await (
      _db.update(_db.wallets)..where((t) => t.id.equals(_walletId))
    ).write(
      WalletsCompanion(
        currentPoints: Value(current.currentPoints - points),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final row = await (
      _db.select(_db.wallets)..where((t) => t.id.equals(_walletId))
    ).getSingle();
    return Result.success(_rowToWallet(row));
  }

  Wallet _rowToWallet(WalletRow row) {
    return Wallet(
      id: row.id,
      currentPoints: row.currentPoints,
      updatedAt: row.updatedAt,
    );
  }
}
