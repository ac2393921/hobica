import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hobica/core/utils/date_utils.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_detail_provider.freezed.dart';
part 'habit_detail_provider.g.dart';

@freezed
class HabitDetailState with _$HabitDetailState {
  const factory HabitDetailState({
    required Habit habit,
    required List<HabitLog> logs,
  }) = _HabitDetailState;
}

extension HabitDetailStateX on HabitDetailState {
  /// 今日から遡って連続達成日数を計算する。
  int get streakDays {
    if (logs.isEmpty) return 0;

    final completedDateSet =
        logs.map((log) => log.date.toDate()).toSet();

    var streak = 0;
    var current = DateTime.now().toDate();

    while (completedDateSet.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// date を正規化した達成日の Set を返す。
  Set<DateTime> get completedDates =>
      logs.map((log) => log.date.toDate()).toSet();
}

@riverpod
Future<HabitDetailState?> habitDetail(HabitDetailRef ref, int habitId) async {
  final repo = ref.watch(habitRepositoryProvider);
  final habit = await repo.fetchHabitById(habitId);
  if (habit == null) return null;
  final logs = await repo.fetchHabitLogs();
  return HabitDetailState(
    habit: habit,
    logs: logs.where((HabitLog l) => l.habitId == habitId).toList(),
  );
}
