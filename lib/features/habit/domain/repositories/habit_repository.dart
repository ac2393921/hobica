import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';

abstract interface class HabitRepository {
  Future<List<Habit>> fetchAllHabits();

  Future<Habit?> fetchHabitById(int id);

  Future<Result<Habit, AppError>> createHabit({
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    DateTime? remindTime,
  });

  Future<Result<Habit, AppError>> updateHabit(Habit habit);

  Future<Result<void, AppError>> deleteHabit(int id);

  Future<Result<HabitLog, AppError>> completeHabit(int habitId);
}
