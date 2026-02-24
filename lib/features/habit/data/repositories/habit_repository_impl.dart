import 'package:drift/drift.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/core/utils/date_utils.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  const HabitRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Habit>> fetchAllHabits() async {
    final rows = await (
      _db.select(_db.habits)..where((t) => t.isActive.equals(true))
    ).get();
    return rows.map(_rowToHabit).toList();
  }

  @override
  Future<Habit?> fetchHabitById(int id) async {
    final row = await (
      _db.select(_db.habits)
        ..where((t) => t.id.equals(id) & t.isActive.equals(true))
    ).getSingleOrNull();
    return row == null ? null : _rowToHabit(row);
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

    final row = await _db.into(_db.habits).insertReturning(
          HabitsCompanion.insert(
            title: title,
            points: points,
            frequencyType: frequencyType.name,
            frequencyValue: frequencyValue,
            remindTime: Value(remindTime),
            createdAt: DateTime.now(),
          ),
        );
    return Result.success(_rowToHabit(row));
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

    final count = await (
      _db.update(_db.habits)
        ..where((t) => t.id.equals(habit.id) & t.isActive.equals(true))
    ).write(
      HabitsCompanion(
        title: Value(habit.title),
        points: Value(habit.points),
        frequencyType: Value(habit.frequencyType.name),
        frequencyValue: Value(habit.frequencyValue),
        remindTime: Value(habit.remindTime),
      ),
    );
    if (count == 0) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }
    return Result.success(habit);
  }

  @override
  Future<Result<void, AppError>> deleteHabit(int id) async {
    final count = await (
      _db.update(_db.habits)
        ..where((t) => t.id.equals(id) & t.isActive.equals(true))
    ).write(const HabitsCompanion(isActive: Value(false)));
    if (count == 0) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }
    return const Result.success(null);
  }

  @override
  Future<List<HabitLog>> fetchHabitLogs() async {
    final rows = await _db.select(_db.habitLogs).get();
    return rows.map(_rowToHabitLog).toList();
  }

  @override
  Future<Result<HabitLog, AppError>> completeHabit(int habitId) async {
    final habit = await (
      _db.select(_db.habits)
        ..where((t) => t.id.equals(habitId) & t.isActive.equals(true))
    ).getSingleOrNull();
    if (habit == null) {
      return const Result.failure(AppError.notFound('習慣が見つかりません'));
    }

    final today = DateTime.now().toDate();
    final existing = await (
      _db.select(_db.habitLogs)
        ..where((t) => t.habitId.equals(habitId) & t.date.equals(today))
    ).getSingleOrNull();
    if (existing != null) {
      return const Result.failure(AppError.alreadyCompleted('本日は既に完了済みです'));
    }

    final row = await _db.into(_db.habitLogs).insertReturning(
          HabitLogsCompanion.insert(
            habitId: habitId,
            date: today,
            points: habit.points,
            createdAt: DateTime.now(),
          ),
        );
    return Result.success(_rowToHabitLog(row));
  }

  Habit _rowToHabit(HabitRow row) {
    return Habit(
      id: row.id,
      title: row.title,
      points: row.points,
      frequencyType: FrequencyType.values.byName(row.frequencyType),
      frequencyValue: row.frequencyValue,
      remindTime: row.remindTime,
      createdAt: row.createdAt,
      isActive: row.isActive,
    );
  }

  HabitLog _rowToHabitLog(HabitLogRow row) {
    return HabitLog(
      id: row.id,
      habitId: row.habitId,
      date: row.date,
      points: row.points,
      createdAt: row.createdAt,
    );
  }
}
