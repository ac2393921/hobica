import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/providers/habit_form_provider.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/mocks/fixtures.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';

void main() {
  late ProviderContainer container;
  late MockHabitRepository mockRepo;

  setUp(() {
    mockRepo = MockHabitRepository();
    container = ProviderContainer(
      overrides: [
        habitRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('HabitFormState', () {
    test('initial() creates empty state with defaults', () {
      final state = HabitFormState.initial();

      expect(state.title, '');
      expect(state.points, 30);
      expect(state.frequencyType, FrequencyType.daily);
      expect(state.frequencyValue, 1);
      expect(state.remindTime, isNull);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
    });

    test('fromHabit() populates state from existing habit', () {
      final habit = HabitFixtures.initialHabits().first;

      final state = HabitFormState.fromHabit(habit);

      expect(state.title, habit.title);
      expect(state.points, habit.points);
      expect(state.frequencyType, habit.frequencyType);
      expect(state.frequencyValue, habit.frequencyValue);
      expect(state.remindTime, habit.remindTime);
    });
  });

  group('HabitForm (create mode)', () {
    test('initial state has empty title and default values', () {
      final state = container.read(habitFormProvider());

      expect(state.title, '');
      expect(state.points, 30);
    });

    test('updateTitle updates title and clears error', () {
      container.read(habitFormProvider().notifier).updateTitle('ヨガ');

      final state = container.read(habitFormProvider());
      expect(state.title, 'ヨガ');
      expect(state.error, isNull);
    });

    test('updatePoints updates points', () {
      container.read(habitFormProvider().notifier).updatePoints(50);

      final state = container.read(habitFormProvider());
      expect(state.points, 50);
    });

    test('updateFrequencyType updates frequencyType', () {
      container
          .read(habitFormProvider().notifier)
          .updateFrequencyType(FrequencyType.weekly);

      final state = container.read(habitFormProvider());
      expect(state.frequencyType, FrequencyType.weekly);
    });

    test('updateFrequencyValue updates frequencyValue', () {
      container.read(habitFormProvider().notifier).updateFrequencyValue(3);

      final state = container.read(habitFormProvider());
      expect(state.frequencyValue, 3);
    });

    test('updateRemindTime updates remindTime', () {
      final time = DateTime(2026, 3, 1, 7, 0);
      container.read(habitFormProvider().notifier).updateRemindTime(time);

      final state = container.read(habitFormProvider());
      expect(state.remindTime, time);
    });

    test('submit with valid data creates new habit', () async {
      final notifier = container.read(habitFormProvider().notifier);
      notifier.updateTitle('ヨガ');
      notifier.updatePoints(40);

      final result = await notifier.submit();

      expect(result, isA<Success<Habit, AppError>>());
      expect(container.read(habitFormProvider()).isSubmitting, isFalse);
      expect(container.read(habitFormProvider()).error, isNull);
    });

    test('submit with empty title returns validation error', () async {
      final notifier = container.read(habitFormProvider().notifier);

      final result = await notifier.submit();

      expect(result, isA<Failure<Habit, AppError>>());
      final state = container.read(habitFormProvider());
      expect(state.error, isA<ValidationError>());
      expect(state.isSubmitting, isFalse);
    });

    test('submit success invalidates habitListProvider', () async {
      await container.read(habitListProvider.future);
      final initialHabits = await container.read(habitListProvider.future);
      expect(initialHabits.length, 2);

      final notifier = container.read(habitFormProvider().notifier);
      notifier.updateTitle('ヨガ');
      await notifier.submit();

      final updatedHabits = await container.read(habitListProvider.future);
      expect(updatedHabits.length, 3);
    });

    test('delete in create mode returns success without modifying repository',
        () async {
      final notifier = container.read(habitFormProvider().notifier);

      final result = await notifier.delete();

      expect(result, isA<Success<void, AppError>>());
      // Repository should be unchanged
      final habits = await mockRepo.fetchAllHabits();
      expect(habits.length, 2);
    });
  });

  group('HabitForm (edit mode)', () {
    test('initial state populated from habit', () {
      final habit = HabitFixtures.initialHabits().first;

      final state = container.read(habitFormProvider(initialHabit: habit));

      expect(state.title, habit.title);
      expect(state.points, habit.points);
      expect(state.frequencyType, habit.frequencyType);
      expect(state.frequencyValue, habit.frequencyValue);
    });

    test('submit updates existing habit', () async {
      final habit = HabitFixtures.initialHabits().first;
      final notifier =
          container.read(habitFormProvider(initialHabit: habit).notifier);
      notifier.updateTitle('読書 1時間');
      notifier.updatePoints(60);

      final result = await notifier.submit();

      expect(result, isA<Success<Habit, AppError>>());
      final updated = await mockRepo.fetchHabitById(habit.id);
      expect(updated!.title, '読書 1時間');
      expect(updated.points, 60);
    });

    test('delete logically deletes habit from repository', () async {
      final habit = HabitFixtures.initialHabits().first;
      final notifier =
          container.read(habitFormProvider(initialHabit: habit).notifier);

      final result = await notifier.delete();

      expect(result, isA<Success<void, AppError>>());
      final fetched = await mockRepo.fetchHabitById(habit.id);
      expect(fetched, isNull);
    });

    test('delete success invalidates habitListProvider', () async {
      await container.read(habitListProvider.future);

      final habit = HabitFixtures.initialHabits().first;
      final notifier =
          container.read(habitFormProvider(initialHabit: habit).notifier);
      await notifier.delete();

      final habits = await container.read(habitListProvider.future);
      expect(habits.length, 1);
    });
  });
}
