import 'package:hobica/core/database/providers/database_provider.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/data/datasources/habit_local_data_source.dart';
import 'package:hobica/features/habit/data/repositories/habit_repository_impl.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_list_provider.g.dart';

@riverpod
HabitLocalDataSource habitLocalDataSource(HabitLocalDataSourceRef ref) {
  return HabitLocalDataSource(ref.watch(appDatabaseProvider));
}

@riverpod
HabitRepository habitRepository(HabitRepositoryRef ref) {
  return HabitRepositoryImpl(ref.watch(habitLocalDataSourceProvider));
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
