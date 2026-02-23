import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

void main() {
  late MockWalletRepository repository;

  setUp(() {
    repository = MockWalletRepository();
  });

  group('MockWalletRepository', () {
    group('getWallet', () {
      test('returns wallet with 0 points initially', () async {
        final wallet = await repository.getWallet();
        expect(wallet.currentPoints, 0);
        expect(wallet.id, 1);
      });
    });

    group('addPoints', () {
      test('increases currentPoints by given amount', () async {
        await repository.addPoints(50);
        final wallet = await repository.getWallet();
        expect(wallet.currentPoints, 50);
      });

      test('accumulates multiple additions', () async {
        await repository.addPoints(30);
        await repository.addPoints(20);

        final wallet = await repository.getWallet();
        expect(wallet.currentPoints, 50);
      });

      test('returns updated wallet', () async {
        final wallet = await repository.addPoints(100);
        expect(wallet, isA<Wallet>());
        expect(wallet.currentPoints, 100);
      });
    });

    group('subtractPoints', () {
      test('returns insufficientPoints when points > currentPoints', () async {
        final result = await repository.subtractPoints(10);
        expect(result, isA<Failure<Wallet, AppError>>());
        expect(
          (result as Failure<Wallet, AppError>).error,
          isA<InsufficientPointsError>(),
        );
      });

      test('returns insufficientPoints when points == currentPoints + 1',
          () async {
        await repository.addPoints(99);

        final result = await repository.subtractPoints(100);
        expect(result, isA<Failure<Wallet, AppError>>());
        expect(
          (result as Failure<Wallet, AppError>).error,
          isA<InsufficientPointsError>(),
        );
      });

      test('succeeds when points == currentPoints', () async {
        await repository.addPoints(100);

        final result = await repository.subtractPoints(100);
        expect(result, isA<Success<Wallet, AppError>>());

        final wallet = (result as Success<Wallet, AppError>).value;
        expect(wallet.currentPoints, 0);
      });

      test('succeeds when points < currentPoints', () async {
        await repository.addPoints(100);

        final result = await repository.subtractPoints(60);
        expect(result, isA<Success<Wallet, AppError>>());

        final wallet = (result as Success<Wallet, AppError>).value;
        expect(wallet.currentPoints, 40);
      });

      test('persists the subtraction in subsequent getWallet', () async {
        await repository.addPoints(100);
        await repository.subtractPoints(30);

        final wallet = await repository.getWallet();
        expect(wallet.currentPoints, 70);
      });
    });
  });
}
