import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_completion_provider.g.dart';

/// 今日完了した習慣IDセットを管理するプロバイダー。
///
/// [HabitList] は AsyncNotifier<List<Habit>> のため完了IDセットを持てない。
/// 関心を分離するために独立した Notifier として定義する。
@riverpod
class HabitCompletion extends _$HabitCompletion {
  @override
  Set<int> build() => const {};

  Future<Result<HabitLog, AppError>> completeHabit(int habitId) async {
    final result =
        await ref.read(habitRepositoryProvider).completeHabit(habitId);
    if (result is Success) {
      state = {...state, habitId};
    }
    return result;
  }
}
