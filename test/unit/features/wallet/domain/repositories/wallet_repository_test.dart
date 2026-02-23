import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';

class _FakeWalletRepository implements WalletRepository {
  int _currentPoints = 1000;

  @override
  Future<Wallet> getWallet() async => Wallet(
        id: 1,
        currentPoints: _currentPoints,
        updatedAt: DateTime(2026, 2, 22),
      );

  @override
  Future<Wallet> addPoints(int points) async {
    _currentPoints += points;
    return Wallet(
      id: 1,
      currentPoints: _currentPoints,
      updatedAt: DateTime(2026, 2, 22),
    );
  }

  @override
  Future<Result<Wallet, AppError>> subtractPoints(int points) async {
    if (_currentPoints < points) {
      return const Result.failure(
        AppError.insufficientPoints('ポイントが不足しています'),
      );
    }
    _currentPoints -= points;
    return Result.success(Wallet(
      id: 1,
      currentPoints: _currentPoints,
      updatedAt: DateTime(2026, 2, 22),
    ),);
  }
}

void main() {
  group('WalletRepository インターフェースコントラクト', () {
    late WalletRepository repository;

    setUp(() => repository = _FakeWalletRepository());

    test('getWallet は Wallet を返す', () async {
      final result = await repository.getWallet();
      expect(result, isA<Wallet>());
    });

    test('addPoints は加算後の Wallet を返す', () async {
      final result = await repository.addPoints(100);
      expect(result, isA<Wallet>());
      expect(result.currentPoints, 1100);
    });

    test('subtractPoints は減算後の Wallet を Success で返す', () async {
      final result = await repository.subtractPoints(200);
      expect(result, isA<Result<Wallet, AppError>>());
      result.when(
        success: (wallet) => expect(wallet.currentPoints, 800),
        failure: (_) => fail('Success を期待したが Failure が返った'),
      );
    });

    test('subtractPoints はポイント不足時に insufficientPoints エラーを返す', () async {
      final result = await repository.subtractPoints(9999);
      expect(result, isA<Result<Wallet, AppError>>());
      result.when(
        success: (_) => fail('Failure を期待したが Success が返った'),
        failure: (error) => expect(
          error,
          isA<InsufficientPointsError>(),
        ),
      );
    });
  });
}
