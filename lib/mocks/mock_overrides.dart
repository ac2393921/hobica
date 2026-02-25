import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:hobica/mocks/mock_history_repository.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:hobica/mocks/mock_settings_repository.dart';
import 'package:hobica/mocks/mock_wallet_repository.dart';

/// モックRepository のプロバイダーオーバーライド一覧。
///
/// フロント優先実装フェーズではデータベースを使用せず、
/// メモリ内モックRepositoryでアプリを動作させる。
/// 実データ連携フェーズ（Phase 14）でこのオーバーライドを除去し、
/// 各プロバイダーが生成する実 RepositoryImpl に切り替える。
final List<Override> mockRepositoryOverrides = [
  habitRepositoryProvider.overrideWithValue(MockHabitRepository()),
  rewardRepositoryProvider.overrideWithValue(MockRewardRepository()),
  walletRepositoryProvider.overrideWithValue(MockWalletRepository()),
  historyRepositoryProvider.overrideWithValue(MockHistoryRepository()),
  settingsRepositoryProvider.overrideWithValue(MockSettingsRepository()),
];
