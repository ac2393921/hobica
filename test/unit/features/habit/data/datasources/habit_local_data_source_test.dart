import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/features/habit/data/datasources/habit_local_data_source.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late HabitLocalDataSource dataSource;

  setUp(() {
    db = _createInMemoryDb();
    dataSource = HabitLocalDataSource(db);
  });

  tearDown(() async {
    await db.close();
  });

  HabitsCompanion _buildHabitCompanion({
    required String title,
    int points = 10,
    String frequencyType = 'daily',
    int frequencyValue = 1,
  }) {
    return HabitsCompanion.insert(
      title: title,
      points: points,
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
      createdAt: DateTime.now(),
    );
  }

  group('HabitLocalDataSource', () {
    group('fetchActiveHabits', () {
      test('returns empty list when no habits exist', () async {
        final habits = await dataSource.fetchActiveHabits();
        expect(habits, isEmpty);
      });

      test('returns only active habits', () async {
        await dataSource.insertHabit(_buildHabitCompanion(title: 'Active'));
        final toDelete = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'Inactive'),
        );
        await dataSource.softDeleteHabit(toDelete.id);

        final habits = await dataSource.fetchActiveHabits();
        expect(habits, hasLength(1));
        expect(habits.first.title, 'Active');
      });
    });

    group('fetchActiveHabitById', () {
      test('returns habit when it exists and is active', () async {
        final inserted = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'Test'),
        );

        final found = await dataSource.fetchActiveHabitById(inserted.id);
        expect(found, isNotNull);
        expect(found!.title, 'Test');
      });

      test('returns null when habit does not exist', () async {
        final found = await dataSource.fetchActiveHabitById(999);
        expect(found, isNull);
      });

      test('returns null when habit is inactive', () async {
        final inserted = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'Deleted'),
        );
        await dataSource.softDeleteHabit(inserted.id);

        final found = await dataSource.fetchActiveHabitById(inserted.id);
        expect(found, isNull);
      });
    });

    group('insertHabit', () {
      test('inserts and returns the habit row', () async {
        final row = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'New Habit', points: 30),
        );

        expect(row.title, 'New Habit');
        expect(row.points, 30);
        expect(row.isActive, isTrue);
      });
    });

    group('updateActiveHabit', () {
      test('updates an active habit and returns affected row count', () async {
        final inserted = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'Before'),
        );

        final count = await dataSource.updateActiveHabit(
          inserted.id,
          const HabitsCompanion(title: Value('After')),
        );

        expect(count, 1);
        final updated = await dataSource.fetchActiveHabitById(inserted.id);
        expect(updated!.title, 'After');
      });

      test('returns 0 when habit does not exist', () async {
        final count = await dataSource.updateActiveHabit(
          999,
          const HabitsCompanion(title: Value('Ghost')),
        );

        expect(count, 0);
      });
    });

    group('softDeleteHabit', () {
      test('sets isActive to false and returns affected row count', () async {
        final inserted = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'ToDelete'),
        );

        final count = await dataSource.softDeleteHabit(inserted.id);
        expect(count, 1);

        final found = await dataSource.fetchActiveHabitById(inserted.id);
        expect(found, isNull);
      });

      test('returns 0 when habit does not exist', () async {
        final count = await dataSource.softDeleteHabit(999);
        expect(count, 0);
      });
    });

    group('fetchAllLogs', () {
      test('returns empty list when no logs exist', () async {
        final logs = await dataSource.fetchAllLogs();
        expect(logs, isEmpty);
      });

      test('returns all logs', () async {
        final habit = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'Habit'),
        );
        final today = DateTime(2025, 1, 1);
        await dataSource.insertLog(
          HabitLogsCompanion.insert(
            habitId: habit.id,
            date: today,
            points: 10,
            createdAt: DateTime.now(),
          ),
        );

        final logs = await dataSource.fetchAllLogs();
        expect(logs, hasLength(1));
        expect(logs.first.habitId, habit.id);
      });
    });

    group('fetchLogByHabitIdAndDate', () {
      test('returns log when it exists', () async {
        final habit = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'Habit'),
        );
        final today = DateTime(2025, 1, 1);
        await dataSource.insertLog(
          HabitLogsCompanion.insert(
            habitId: habit.id,
            date: today,
            points: 10,
            createdAt: DateTime.now(),
          ),
        );

        final found = await dataSource.fetchLogByHabitIdAndDate(
          habit.id,
          today,
        );
        expect(found, isNotNull);
        expect(found!.habitId, habit.id);
      });

      test('returns null when log does not exist', () async {
        final found = await dataSource.fetchLogByHabitIdAndDate(
          999,
          DateTime(2025, 1, 1),
        );
        expect(found, isNull);
      });
    });

    group('insertLog', () {
      test('inserts and returns the log row', () async {
        final habit = await dataSource.insertHabit(
          _buildHabitCompanion(title: 'Habit'),
        );
        final today = DateTime(2025, 1, 1);

        final row = await dataSource.insertLog(
          HabitLogsCompanion.insert(
            habitId: habit.id,
            date: today,
            points: 20,
            createdAt: DateTime.now(),
          ),
        );

        expect(row.habitId, habit.id);
        expect(row.points, 20);
      });
    });
  });
}
