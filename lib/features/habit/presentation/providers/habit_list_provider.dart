import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_list_provider.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
HabitRepository habitRepository(HabitRepositoryRef ref) {
  return MockHabitRepository();
}

@riverpod
class HabitList extends _$HabitList {
  @override
  Future<List<Habit>> build() async {
    final repository = ref.watch(habitRepositoryProvider);
    return repository.fetchAllHabits();
  }

  Future<Result<void, AppError>> deleteHabit(int id) async {
    final result = await ref.read(habitRepositoryProvider).deleteHabit(id);
    if (result is Success) {
      ref.invalidateSelf();
    }
    return result;
  }
}
