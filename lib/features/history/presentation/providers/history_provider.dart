import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/history_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_provider.g.dart';

@riverpod
class HistoryHabitLogs extends _$HistoryHabitLogs {
  @override
  Future<List<HabitLog>> build() async {
    return ref.watch(historyRepositoryProvider).fetchHabitLogs();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class HistoryRedemptions extends _$HistoryRedemptions {
  @override
  Future<List<RewardRedemption>> build() async {
    return ref.watch(historyRepositoryProvider).fetchRedemptions();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
