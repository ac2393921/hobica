import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
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

  group('HabitList', () {
    test('initial state loads all active habits from repository', () async {
      final habits = await container.read(habitListProvider.future);

      expect(habits.length, 2);
    });

    test('deleteHabit removes habit and refreshes list', () async {
      await container.read(habitListProvider.future);

      await container.read(habitListProvider.notifier).deleteHabit(1);

      final habits = await container.read(habitListProvider.future);
      expect(habits.length, 1);
      expect(habits.first.id, 2);
    });

    test('deleteHabit with non-existent id returns Failure and does not update list', () async {
      await container.read(habitListProvider.future);

      final result = await container.read(habitListProvider.notifier).deleteHabit(999);

      expect(result, isA<Failure<void, AppError>>());
      final habits = await container.read(habitListProvider.future);
      expect(habits.length, 2);
    });
  });
}
