import 'package:drift/drift.dart';
import 'package:hobica/core/database/app_database.dart';

class HabitLocalDataSource {
  const HabitLocalDataSource(this._db);

  final AppDatabase _db;

  Future<List<HabitRow>> fetchActiveHabits() {
    return (_db.select(_db.habits)
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  Future<HabitRow?> fetchActiveHabitById(int id) {
    return (_db.select(_db.habits)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<HabitRow> insertHabit(HabitsCompanion companion) {
    return _db.into(_db.habits).insertReturning(companion);
  }

  Future<int> updateActiveHabit(int id, HabitsCompanion companion) {
    return (_db.update(_db.habits)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .write(companion);
  }

  Future<int> softDeleteHabit(int id) {
    return (_db.update(_db.habits)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .write(const HabitsCompanion(isActive: Value(false)));
  }

  Future<List<HabitLogRow>> fetchAllLogs() {
    return _db.select(_db.habitLogs).get();
  }

  Future<HabitLogRow?> fetchLogByHabitIdAndDate(int habitId, DateTime date) {
    return (_db.select(_db.habitLogs)
          ..where((t) => t.habitId.equals(habitId) & t.date.equals(date)))
        .getSingleOrNull();
  }

  Future<HabitLogRow> insertLog(HabitLogsCompanion companion) {
    return _db.into(_db.habitLogs).insertReturning(companion);
  }
}
