import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';
import 'package:hobica/mocks/fixtures.dart';

class MockHabitRepository implements HabitRepository {
  MockHabitRepository() {
    _habits.addAll(HabitFixtures.initialHabits());
    _nextId = _habits.isEmpty ? 1 : _habits.last.id + 1;
  }

  final List<Habit> _habits = [];
  int _nextId = 1;

  @override
  Future<List<Habit>> fetchAllHabits() async {
    return _habits.where((h) => h.isActive).toList();
  }

  @override
  Future<Habit?> fetchHabitById(int id) async {
    final matches = _habits.where((h) => h.id == id && h.isActive);
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
      return const Result.failure(
        AppError.validation('タイトルは1〜50文字で入力してください'),
      );
    }
    if (points < 1) {
      return const Result.failure(
        AppError.validation('ポイントは1以上を入力してください'),
      );
    }
    final habit = Habit(
      id: _nextId++,
      title: title,
      points: points,
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
      remindTime: remindTime,
      createdAt: DateTime.now(),
    );
    _habits.add(habit);
    return Result.success(habit);
  }

  @override
  Future<Result<Habit, AppError>> updateHabit(Habit habit) async {
    if (habit.title.isEmpty || habit.title.length > 50) {
      return const Result.failure(
        AppError.validation('タイトルは1〜50文字で入力してください'),
      );
    }
    if (habit.points < 1) {
      return const Result.failure(
        AppError.validation('ポイントは1以上を入力してください'),
      );
    }
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }
    _habits[index] = habit;
    return Result.success(habit);
  }

  @override
  Future<Result<void, AppError>> deleteHabit(int id) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }
    _habits[index] = _habits[index].copyWith(isActive: false);
    return const Result.success(null);
  }
}
