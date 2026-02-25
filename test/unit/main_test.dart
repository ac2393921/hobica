import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/database/providers/database_provider.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/settings/domain/repositories/settings_repository.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:hobica/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_history_repository.dart';
import 'package:hobica/mocks/mock_overrides.dart';
import 'package:hobica/mocks/mock_settings_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

void main() {
  group('mockRepositoryOverrides', () {
    test('全3つのRepositoryプロバイダーをオーバーライドする', () {
      expect(mockRepositoryOverrides, hasLength(3));
    });

    test('モックRepositoryがProviderScopeで正しく注入される', () {
      final container = ProviderContainer(overrides: mockRepositoryOverrides);
      addTearDown(container.dispose);

      expect(
        container.read(walletRepositoryProvider),
        isA<MockWalletRepository>(),
      );
      expect(container.read(walletRepositoryProvider), isA<WalletRepository>());

      expect(
        container.read(historyRepositoryProvider),
        isA<MockHistoryRepository>(),
      );
      expect(
        container.read(historyRepositoryProvider),
        isA<HistoryRepository>(),
      );

      expect(
        container.read(settingsRepositoryProvider),
        isA<MockSettingsRepository>(),
      );
      expect(
        container.read(settingsRepositoryProvider),
        isA<SettingsRepository>(),
      );
    });

    test('モック対象3つはappDatabaseProviderなしでも動作する', () {
      final container = ProviderContainer(overrides: mockRepositoryOverrides);
      addTearDown(container.dispose);

      expect(() => container.read(walletRepositoryProvider), returnsNormally);
      expect(() => container.read(historyRepositoryProvider), returnsNormally);
      expect(() => container.read(settingsRepositoryProvider), returnsNormally);
    });

    test('appDatabaseProvider経由でhabitRepositoryが動作する', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          ...mockRepositoryOverrides,
        ],
      );
      addTearDown(() async {
        container.dispose();
        await db.close();
      });

      final repo = container.read(habitRepositoryProvider);
      expect(repo, isA<HabitRepository>());
    });

    test('appDatabaseProvider経由でrewardRepositoryが動作する', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          ...mockRepositoryOverrides,
        ],
      );
      addTearDown(() async {
        container.dispose();
        await db.close();
      });

      final repo = container.read(rewardRepositoryProvider);
      expect(repo, isA<RewardRepositoryImpl>());
      expect(repo, isA<RewardRepository>());
    });
  });
}
