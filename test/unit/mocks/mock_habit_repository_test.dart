import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';

void main() {
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
  });

  group('MockHabitRepository', () {
    group('fetchAllHabits', () {
      test('returns empty list initially', () async {
        final result = await repository.fetchAllHabits();
        expect(result, isEmpty);
      });

      test('returns all created habits', () async {
        await repository.createHabit(
          title: 'Morning Run',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        await repository.createHabit(
          title: 'Evening Read',
          points: 5,
          frequencyType: FrequencyType.weekly,
          frequencyValue: 3,
        );

        final habits = await repository.fetchAllHabits();
        expect(habits.length, 2);
      });
    });

    group('fetchHabitById', () {
      test('returns null for non-existent id', () async {
        final result = await repository.fetchHabitById(999);
        expect(result, isNull);
      });

      test('returns habit for existing id', () async {
        final created = await repository.createHabit(
          title: 'Morning Run',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final id = (created as Success<Habit, AppError>).value.id;

        final result = await repository.fetchHabitById(id);
        expect(result, isNotNull);
        expect(result!.title, 'Morning Run');
      });
    });

    group('createHabit', () {
      test('returns success with auto-incremented id', () async {
        final result1 = await repository.createHabit(
          title: 'Habit A',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final result2 = await repository.createHabit(
          title: 'Habit B',
          points: 5,
          frequencyType: FrequencyType.weekly,
          frequencyValue: 2,
        );

        expect(result1, isA<Success<Habit, AppError>>());
        expect(result2, isA<Success<Habit, AppError>>());

        final id1 = (result1 as Success<Habit, AppError>).value.id;
        final id2 = (result2 as Success<Habit, AppError>).value.id;
        expect(id2, id1 + 1);
      });

      test('stores habit with provided fields', () async {
        final result = await repository.createHabit(
          title: 'Morning Run',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );

        final habit = (result as Success<Habit, AppError>).value;
        expect(habit.title, 'Morning Run');
        expect(habit.points, 10);
        expect(habit.frequencyType, FrequencyType.daily);
        expect(habit.frequencyValue, 1);
        expect(habit.remindTime, isNull);
        expect(habit.isActive, isTrue);
      });
    });

    group('updateHabit', () {
      test('returns failure for non-existent habit', () async {
        final nonExistent = Habit(
          id: 999,
          title: 'Ghost',
          points: 1,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
          createdAt: DateTime.now(),
        );

        final result = await repository.updateHabit(nonExistent);
        expect(result, isA<Failure<Habit, AppError>>());
        expect(
          (result as Failure<Habit, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('updates and returns modified habit', () async {
        final created = await repository.createHabit(
          title: 'Old Title',
          points: 5,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habit = (created as Success<Habit, AppError>).value;

        final updated = habit.copyWith(title: 'New Title', points: 20);
        final result = await repository.updateHabit(updated);

        expect(result, isA<Success<Habit, AppError>>());
        final returned = (result as Success<Habit, AppError>).value;
        expect(returned.title, 'New Title');
        expect(returned.points, 20);

        final fetched = await repository.fetchHabitById(habit.id);
        expect(fetched!.title, 'New Title');
      });
    });

    group('deleteHabit', () {
      test('returns failure for non-existent id', () async {
        final result = await repository.deleteHabit(999);
        expect(result, isA<Failure<void, AppError>>());
        expect(
          (result as Failure<void, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('removes habit on success', () async {
        final created = await repository.createHabit(
          title: 'To Delete',
          points: 5,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final id = (created as Success<Habit, AppError>).value.id;

        final deleteResult = await repository.deleteHabit(id);
        expect(deleteResult, isA<Success<void, AppError>>());

        final fetched = await repository.fetchHabitById(id);
        expect(fetched, isNull);
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
        final created = await repository.createHabit(
          title: 'Morning Run',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitId = (created as Success<Habit, AppError>).value.id;

        final result = await repository.completeHabit(habitId);
        expect(result, isA<Success<HabitLog, AppError>>());

        final log = (result as Success<HabitLog, AppError>).value;
        expect(log.habitId, habitId);
        expect(log.points, 10);
      });

      test('returns alreadyCompleted on same-day duplicate', () async {
        final created = await repository.createHabit(
          title: 'Morning Run',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitId = (created as Success<Habit, AppError>).value.id;

        await repository.completeHabit(habitId);
        final result = await repository.completeHabit(habitId);

        expect(result, isA<Failure<HabitLog, AppError>>());
        expect(
          (result as Failure<HabitLog, AppError>).error,
          isA<AlreadyCompletedError>(),
        );
      });

      test('stores log accessible via habitLogs getter', () async {
        final created = await repository.createHabit(
          title: 'Morning Run',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitId = (created as Success<Habit, AppError>).value.id;

        await repository.completeHabit(habitId);
        expect(repository.habitLogs.length, 1);
        expect(repository.habitLogs.first.habitId, habitId);
      });
    });
  });
}
