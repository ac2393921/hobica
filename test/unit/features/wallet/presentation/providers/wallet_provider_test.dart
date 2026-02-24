import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';
import 'package:hobica/mocks/wallet_repository_provider.dart';

void main() {
  group('WalletBalanceProvider', () {
    late ProviderContainer container;
    late MockWalletRepository mockRepository;

    setUp(() {
      mockRepository = MockWalletRepository();
      container = ProviderContainer(
        overrides: [
          walletRepositoryProvider.overrideWith((_) => mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は AsyncLoading', () {
      final state = container.read(walletBalanceProvider);
      expect(state, isA<AsyncLoading<Wallet>>());
    });

    test('getWallet() が返す Wallet を正しく公開する', () async {
      final result = await container.read(walletBalanceProvider.future);
      expect(result, isA<Wallet>());
      expect(result.currentPoints, 0);
    });

    test('walletRepositoryProvider を override して任意の実装を注入できる', () async {
      final customMock = _FixedPointsWalletRepository(points: 500);
      final customContainer = ProviderContainer(
        overrides: [
          walletRepositoryProvider.overrideWith((_) => customMock),
        ],
      );
      addTearDown(customContainer.dispose);

      final result = await customContainer.read(walletBalanceProvider.future);
      expect(result.currentPoints, 500);
    });
  });
}

class _FixedPointsWalletRepository implements WalletRepository {
  _FixedPointsWalletRepository({required this.points});

  final int points;

  @override
  Future<Wallet> getWallet() async => Wallet(
        id: 1,
        currentPoints: points,
        updatedAt: DateTime(2026, 2),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}
