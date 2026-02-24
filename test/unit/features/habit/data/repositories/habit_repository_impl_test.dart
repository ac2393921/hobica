import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/data/repositories/habit_repository_impl.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late HabitRepositoryImpl repo;

  setUp(() {
    db = _createInMemoryDb();
    repo = HabitRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('HabitRepositoryImpl', () {
    group('fetchAllHabits', () {
      test('returns empty list when no habits exist', () async {
        final habits = await repo.fetchAllHabits();
        expect(habits, isEmpty);
      });

      test('returns only active habits', () async {
        await repo.createHabit(
          title: 'Active',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final result = await repo.createHabit(
          title: 'To Delete',
          points: 20,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        if (result is Success<Habit, AppError>) {
          await repo.deleteHabit(result.value.id);
        }

        final habits = await repo.fetchAllHabits();
        expect(habits.length, 1);
        expect(habits.first.title, 'Active');
      });
    });

    group('createHabit', () {
      test('successfully creates a habit', () async {
        final result = await repo.createHabit(
          title: 'Morning Run',
          points: 30,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        expect(result, isA<Success<Habit, AppError>>());
        final habit = (result as Success<Habit, AppError>).value;
        expect(habit.title, 'Morning Run');
        expect(habit.points, 30);
        expect(habit.frequencyType, FrequencyType.daily);
        expect(habit.isActive, isTrue);
      });

      test('returns validation error for empty title', () async {
        final result = await repo.createHabit(
          title: '',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        expect(result, isA<Failure<Habit, AppError>>());
        expect(
          (result as Failure<Habit, AppError>).error,
          isA<ValidationError>(),
        );
      });

      test('returns validation error for zero points', () async {
        final result = await repo.createHabit(
          title: 'Valid',
          points: 0,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        expect(result, isA<Failure<Habit, AppError>>());
      });
    });

    group('fetchHabitById', () {
      test('returns habit when it exists', () async {
        final created = await repo.createHabit(
          title: 'Test',
          points: 10,
          frequencyType: FrequencyType.weekly,
          frequencyValue: 3,
        );
        final id = (created as Success<Habit, AppError>).value.id;

        final found = await repo.fetchHabitById(id);
        expect(found, isNotNull);
        expect(found!.title, 'Test');
      });

      test('returns null when habit does not exist', () async {
        final found = await repo.fetchHabitById(999);
        expect(found, isNull);
      });

      test('returns null after logical deletion', () async {
        final created = await repo.createHabit(
          title: 'Deleted',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final id = (created as Success<Habit, AppError>).value.id;
        await repo.deleteHabit(id);

        final found = await repo.fetchHabitById(id);
        expect(found, isNull);
      });
    });

    group('updateHabit', () {
      test('successfully updates a habit', () async {
        final created = await repo.createHabit(
          title: 'Old Title',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habit = (created as Success<Habit, AppError>).value;

        final result = await repo.updateHabit(
          habit.copyWith(title: 'New Title', points: 20),
        );

        expect(result, isA<Success<Habit, AppError>>());
        final updated = (result as Success<Habit, AppError>).value;
        expect(updated.title, 'New Title');
        expect(updated.points, 20);
      });

      test('returns notFound error for non-existent habit', () async {
        final fakeHabit = Habit(
          id: 999,
          title: 'Ghost',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
          createdAt: DateTime.now(),
        );

        final result = await repo.updateHabit(fakeHabit);
        expect(result, isA<Failure<Habit, AppError>>());
        expect(
          (result as Failure<Habit, AppError>).error,
          isA<NotFoundError>(),
        );
      });
    });

    group('deleteHabit', () {
      test('logically deletes a habit (sets isActive=false)', () async {
        final created = await repo.createHabit(
          title: 'To Delete',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final id = (created as Success<Habit, AppError>).value.id;

        final result = await repo.deleteHabit(id);
        expect(result, isA<Success<void, AppError>>());

        final allHabits = await repo.fetchAllHabits();
        expect(allHabits.where((h) => h.id == id), isEmpty);
      });

      test('returns notFound error for non-existent habit', () async {
        final result = await repo.deleteHabit(999);

        expect(result, isA<Failure<void, AppError>>());
        expect(
          (result as Failure<void, AppError>).error,
          isA<NotFoundError>(),
        );
      });
    });

    group('completeHabit', () {
      test('successfully completes a habit for today', () async {
        final created = await repo.createHabit(
          title: 'Daily Habit',
          points: 50,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitId = (created as Success<Habit, AppError>).value.id;

        final result = await repo.completeHabit(habitId);

        expect(result, isA<Success<HabitLog, AppError>>());
        final log = (result as Success<HabitLog, AppError>).value;
        expect(log.habitId, habitId);
        expect(log.points, 50);
      });

      test('returns alreadyCompleted error on second completion same day',
          () async {
        final created = await repo.createHabit(
          title: 'Daily Habit',
          points: 30,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitId = (created as Success<Habit, AppError>).value.id;

        await repo.completeHabit(habitId);
        final result = await repo.completeHabit(habitId);

        expect(result, isA<Failure<HabitLog, AppError>>());
        expect(
          (result as Failure<HabitLog, AppError>).error,
          isA<AlreadyCompletedError>(),
        );
      });

      test('returns notFound error for non-existent habit', () async {
        final result = await repo.completeHabit(999);

        expect(result, isA<Failure<HabitLog, AppError>>());
        expect(
          (result as Failure<HabitLog, AppError>).error,
          isA<NotFoundError>(),
        );
      });
    });

    group('fetchHabitLogs', () {
      test('returns all habit logs', () async {
        final created = await repo.createHabit(
          title: 'Habit',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitId = (created as Success<Habit, AppError>).value.id;
        await repo.completeHabit(habitId);

        final logs = await repo.fetchHabitLogs();
        expect(logs.length, 1);
        expect(logs.first.habitId, habitId);
      });
    });
  });
}
