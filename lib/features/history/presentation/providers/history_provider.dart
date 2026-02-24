import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/history_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_provider.g.dart';

@riverpod
class PointHistory extends _$PointHistory {
  @override
  Future<List<HabitLog>> build() async {
    return ref.watch(historyRepositoryProvider).fetchHabitLogs();
  }
}

@riverpod
class RedemptionHistory extends _$RedemptionHistory {
  @override
  Future<List<RewardRedemption>> build() async {
    return ref.watch(historyRepositoryProvider).fetchRedemptions();
  }
}
