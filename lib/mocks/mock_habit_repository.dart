import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/core/utils/date_utils.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';
import 'package:hobica/mocks/fixtures.dart';

class MockHabitRepository implements HabitRepository {
  MockHabitRepository() {
    _habits = [...HabitFixtures.initialHabits()];
    _nextHabitId = _habits.isEmpty
        ? 1
        : _habits.map((habit) => habit.id).reduce((a, b) => a > b ? a : b) + 1;
    _nextLogId = _habitLogs.isEmpty
        ? 1
        : _habitLogs.map((log) => log.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  List<Habit> _habits = [];
  List<HabitLog> _habitLogs = [];
  int _nextHabitId = 1;
  int _nextLogId = 1;

  List<HabitLog> get habitLogs => List.unmodifiable(_habitLogs);

  @override
  Future<List<Habit>> fetchAllHabits() async =>
      _habits.where((habit) => habit.isActive).toList(growable: false);

  @override
  Future<Habit?> fetchHabitById(int id) async {
    final matches = _habits.where((habit) => habit.id == id && habit.isActive);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<Result<Habit, AppError>> createHabit({
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    DateTime? remindTime,
  }) async {
    if (title.isEmpty || title.length > 50) {
      return const Result.failure(AppError.validation('タイトルは1〜50文字で入力してください'));
    }
    if (points < 1) {
      return const Result.failure(AppError.validation('ポイントは1以上を入力してください'));
    }

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
    if (habit.title.isEmpty || habit.title.length > 50) {
      return const Result.failure(AppError.validation('タイトルは1〜50文字で入力してください'));
    }
    if (habit.points < 1) {
      return const Result.failure(AppError.validation('ポイントは1以上を入力してください'));
    }

    final index = _habits.indexWhere(
      (entry) => entry.id == habit.id && entry.isActive,
    );
    if (index == -1) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }

    final updatedHabits = [..._habits];
    updatedHabits[index] = habit;
    _habits = updatedHabits;
    return Result.success(habit);
  }

  @override
  Future<Result<void, AppError>> deleteHabit(int id) async {
    final index = _habits.indexWhere(
      (habit) => habit.id == id && habit.isActive,
    );
    if (index == -1) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }

    final updatedHabits = [..._habits];
    updatedHabits[index] = updatedHabits[index].copyWith(isActive: false);
    _habits = updatedHabits;
    return const Result.success(null);
  }

  @override
  Future<Result<HabitLog, AppError>> completeHabit(int habitId) async {
    final matches = _habits.where(
      (habit) => habit.id == habitId && habit.isActive,
    );
    if (matches.isEmpty) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }

    final today = DateTime.now().toDate();
    final alreadyLogged = _habitLogs.any(
      (log) => log.habitId == habitId && log.date.toDate() == today,
    );
    if (alreadyLogged) {
      return const Result.failure(AppError.alreadyCompleted('本日は既に完了済みです'));
    }

    final habit = matches.first;
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
