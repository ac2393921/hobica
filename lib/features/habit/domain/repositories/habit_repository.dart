import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';

abstract class HabitRepository {
  Future<List<Habit>> fetchAllHabits();
  Future<Habit?> fetchHabitById(int id);
  Future<Habit> createHabit({
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    DateTime? remindTime,
  });
  Future<Habit> updateHabit(Habit habit);
  Future<void> deleteHabit(int id);
  Future<Result<HabitLog, AppError>> completeHabit(int habitId);
  Future<List<HabitLog>> fetchHabitLogs(int habitId);
  Future<bool> isCompletedToday(int habitId);
}
