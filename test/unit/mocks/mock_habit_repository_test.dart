import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/mocks/fixtures.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';

void main() {
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
  });

  group('MockHabitRepository', () {
    group('fetchAllHabits', () {
      test('returns initial fixtures', () async {
        final habits = await repository.fetchAllHabits();

        expect(habits.length, 2);
        expect(habits.map((h) => h.title), containsAll(['読書 30分', 'ランニング']));
      });

      test('excludes logically deleted habits', () async {
        await repository.deleteHabit(1);

        final habits = await repository.fetchAllHabits();

        expect(habits.length, 1);
        expect(habits.first.id, 2);
      });
    });

    group('fetchHabitById', () {
      test('returns habit by id', () async {
        final habit = await repository.fetchHabitById(1);

        expect(habit, isNotNull);
        expect(habit!.id, 1);
      });

      test('returns null for non-existent id', () async {
        final habit = await repository.fetchHabitById(999);

        expect(habit, isNull);
      });

      test('returns null for logically deleted habit', () async {
        await repository.deleteHabit(1);

        final habit = await repository.fetchHabitById(1);

        expect(habit, isNull);
      });
    });

    group('createHabit', () {
      test('creates habit and assigns auto-incremented id', () async {
        final result = await repository.createHabit(
          title: '瞑想',
          points: 20,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        expect(result, isA<Success<Habit, AppError>>());
        final habit = (result as Success<Habit, AppError>).value;
        expect(habit.id, greaterThan(2));
        expect(habit.title, '瞑想');
        expect(habit.isActive, isTrue);
      });

      test('created habit appears in fetchAllHabits', () async {
        await repository.createHabit(
          title: '瞑想',
          points: 20,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        final habits = await repository.fetchAllHabits();

        expect(habits.length, 3);
      });

      test('returns validation error for empty title', () async {
        final result = await repository.createHabit(
          title: '',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        expect(result, isA<Failure<dynamic, AppError>>());
        final error = (result as Failure<dynamic, AppError>).error;
        expect(error, isA<ValidationError>());
      });

      test('returns validation error for title exceeding 50 chars', () async {
        final result = await repository.createHabit(
          title: 'a' * 51,
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        expect(result, isA<Failure<dynamic, AppError>>());
      });

      test('returns validation error for points less than 1', () async {
        final result = await repository.createHabit(
          title: '有効なタイトル',
          points: 0,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        expect(result, isA<Failure<dynamic, AppError>>());
        final error = (result as Failure<dynamic, AppError>).error;
        expect(error, isA<ValidationError>());
      });
    });

    group('updateHabit', () {
      test('updates existing habit', () async {
        final habits = await repository.fetchAllHabits();
        final updated = habits.first.copyWith(title: '読書 1時間', points: 60);

        final result = await repository.updateHabit(updated);

        expect(result, isA<Success<dynamic, AppError>>());
        final fetched = await repository.fetchHabitById(updated.id);
        expect(fetched!.title, '読書 1時間');
        expect(fetched.points, 60);
      });

      test('returns notFound error for non-existent habit', () async {
        final nonExistent = HabitFixtures.initialHabits().first.copyWith(
          id: 999,
        );

        final result = await repository.updateHabit(nonExistent);

        expect(result, isA<Failure<dynamic, AppError>>());
        final error = (result as Failure<dynamic, AppError>).error;
        expect(error, isA<NotFoundError>());
      });

      test('returns validation error for empty title', () async {
        final habits = await repository.fetchAllHabits();
        final invalid = habits.first.copyWith(title: '');

        final result = await repository.updateHabit(invalid);

        expect(result, isA<Failure<dynamic, AppError>>());
        final error = (result as Failure<dynamic, AppError>).error;
        expect(error, isA<ValidationError>());
      });

      test('returns validation error for points less than 1', () async {
        final habits = await repository.fetchAllHabits();
        final invalid = habits.first.copyWith(points: 0);

        final result = await repository.updateHabit(invalid);

        expect(result, isA<Failure<dynamic, AppError>>());
        final error = (result as Failure<dynamic, AppError>).error;
        expect(error, isA<ValidationError>());
      });
    });

    group('deleteHabit', () {
      test('logically deletes habit (excludes from fetchAllHabits)', () async {
        final result = await repository.deleteHabit(1);

        expect(result, isA<Success<void, AppError>>());
        final habits = await repository.fetchAllHabits();
        expect(habits.any((h) => h.id == 1), isFalse);
      });

      test('returns notFound error for non-existent id', () async {
        final result = await repository.deleteHabit(999);

        expect(result, isA<Failure<void, AppError>>());
        final error = (result as Failure<void, AppError>).error;
        expect(error, isA<NotFoundError>());
      });
    });

    group('completeHabit', () {
      test('returns failure for non-existent habitId', () async {
        final result = await repository.completeHabit(999);

        expect(result, isA<Failure<HabitLog, AppError>>());
        expect(
          (result as Failure<HabitLog, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('returns HabitLog on first completion', () async {
        final result = await repository.completeHabit(1);

        expect(result, isA<Success<HabitLog, AppError>>());
        final log = (result as Success<HabitLog, AppError>).value;
        expect(log.habitId, 1);
        expect(log.points, 30);
      });

      test('returns alreadyCompleted on same-day duplicate', () async {
        await repository.completeHabit(1);
        final result = await repository.completeHabit(1);

        expect(result, isA<Failure<HabitLog, AppError>>());
        expect(
          (result as Failure<HabitLog, AppError>).error,
          isA<AlreadyCompletedError>(),
        );
      });

      test('stores log accessible via habitLogs getter', () async {
        await repository.completeHabit(1);

        expect(repository.habitLogs.length, 1);
        expect(repository.habitLogs.first.habitId, 1);
      });
    });
  });
}
