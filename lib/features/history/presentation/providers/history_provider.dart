import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hobica/core/database/providers/database_provider.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/history/data/repositories/history_repository_impl.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_provider.freezed.dart';
part 'history_provider.g.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    required List<HabitLog> habitLogs,
    required List<RewardRedemption> redemptions,
  }) = _HistoryState;
}

@riverpod
HistoryRepository historyRepository(HistoryRepositoryRef ref) {
  return HistoryRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
class History extends _$History {
  @override
  Future<HistoryState> build() async {
    final repository = ref.watch(historyRepositoryProvider);
    final habitLogs = await repository.fetchHabitLogs();
    final redemptions = await repository.fetchRedemptions();
    return HistoryState(
      habitLogs: habitLogs,
      redemptions: redemptions,
    );
  }
}
