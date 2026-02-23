import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/core/utils/date_utils.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';

class MockHabitRepository implements HabitRepository {
  List<Habit> _habits = [];
  List<HabitLog> _habitLogs = [];
  int _nextHabitId = 1;
  int _nextLogId = 1;

  List<HabitLog> get habitLogs => List.unmodifiable(_habitLogs);

  @override
  Future<List<Habit>> fetchAllHabits() async => List.unmodifiable(_habits);

  @override
  Future<Habit?> fetchHabitById(int id) async {
    return _habits.where((h) => h.id == id).firstOrNull;
  }

  @override
  Future<Result<Habit, AppError>> createHabit({
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    DateTime? remindTime,
  }) async {
    final habit = Habit(
      id: _nextHabitId++,
      title: title,
      points: points,
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
      remindTime: remindTime,
      createdAt: DateTime.now(),
    );
    _habits = [..._habits, habit];
    return Result.success(habit);
  }

  @override
  Future<Result<Habit, AppError>> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) {
      return Result.failure(
        AppError.notFound('Habit with id ${habit.id} not found'),
      );
    }
    final updated = List<Habit>.from(_habits);
    updated[index] = habit;
    _habits = updated;
    return Result.success(habit);
  }

  @override
  Future<Result<void, AppError>> deleteHabit(int id) async {
    final exists = _habits.any((h) => h.id == id);
    if (!exists) {
      return Result.failure(
        AppError.notFound('Habit with id $id not found'),
      );
    }
    _habits = _habits.where((h) => h.id != id).toList();
    return const Result.success(null);
  }

  @override
  Future<Result<HabitLog, AppError>> completeHabit(int habitId) async {
    final habit = _habits.where((h) => h.id == habitId).firstOrNull;
    if (habit == null) {
      return Result.failure(
        AppError.notFound('Habit with id $habitId not found'),
      );
    }

    final today = DateTime.now().toDate();
    final alreadyLogged = _habitLogs.any(
      (log) => log.habitId == habitId && log.date == today,
    );
    if (alreadyLogged) {
      return Result.failure(
        AppError.alreadyCompleted(
          'Habit $habitId has already been completed today',
        ),
      );
    }

    final log = HabitLog(
      id: _nextLogId++,
      habitId: habitId,
      date: today,
      points: habit.points,
      createdAt: DateTime.now(),
    );
    _habitLogs = [..._habitLogs, log];
    return Result.success(log);
  }
}
