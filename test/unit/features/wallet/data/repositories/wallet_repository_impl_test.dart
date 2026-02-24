import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late WalletRepositoryImpl repo;

  setUp(() {
    db = _createInMemoryDb();
    repo = WalletRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('WalletRepositoryImpl', () {
    group('getWallet', () {
      test('creates default wallet on first call', () async {
        final wallet = await repo.getWallet();

        expect(wallet.id, 1);
        expect(wallet.currentPoints, 0);
      });

      test('returns same wallet on subsequent calls', () async {
        final first = await repo.getWallet();
        final second = await repo.getWallet();

        expect(second.id, first.id);
        expect(second.currentPoints, first.currentPoints);
      });
    });

    group('addPoints', () {
      test('increases wallet balance', () async {
        final wallet = await repo.addPoints(100);

        expect(wallet.currentPoints, 100);
      });

      test('accumulates multiple addPoints calls', () async {
        await repo.addPoints(50);
        final wallet = await repo.addPoints(30);

        expect(wallet.currentPoints, 80);
      });
    });

    group('subtractPoints', () {
      test('decreases wallet balance when sufficient', () async {
        await repo.addPoints(200);
        final result = await repo.subtractPoints(100);

        expect(result, isA<Success<Wallet, AppError>>());
        final wallet = (result as Success<Wallet, AppError>).value;
        expect(wallet.currentPoints, 100);
      });

      test('returns insufficientPoints error when balance is too low',
          () async {
        await repo.addPoints(50);
        final result = await repo.subtractPoints(100);

        expect(result, isA<Failure<Wallet, AppError>>());
        expect(
          (result as Failure<Wallet, AppError>).error,
          isA<InsufficientPointsError>(),
        );
      });

      test('does not modify balance on failure', () async {
        await repo.addPoints(50);
        await repo.subtractPoints(100); // fails

        final wallet = await repo.getWallet();
        expect(wallet.currentPoints, 50);
      });
    });
  });
}
