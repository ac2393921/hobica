import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/home/presentation/providers/home_provider.dart';
import 'package:hobica/mocks/fixtures.dart';
import 'package:hobica/mocks/habit_repository_provider.dart';
import 'package:hobica/mocks/history_repository_provider.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:hobica/mocks/mock_history_repository.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';
import 'package:hobica/mocks/reward_repository_provider.dart';

void main() {
  late MockHabitRepository mockHabitRepo;
  late MockHistoryRepository mockHistoryRepo;
  late MockRewardRepository mockRewardRepo;
  late ProviderContainer container;

  ProviderContainer makeContainer({MockHistoryRepository? historyRepo}) {
    return ProviderContainer(
      overrides: [
        habitRepositoryProvider.overrideWithValue(mockHabitRepo),
        historyRepositoryProvider.overrideWithValue(
          historyRepo ?? mockHistoryRepo,
        ),
        rewardRepositoryProvider.overrideWithValue(mockRewardRepo),
      ],
    );
  }

  setUp(() {
    mockHabitRepo = MockHabitRepository();
    mockHistoryRepo = MockHistoryRepository();
    mockRewardRepo = MockRewardRepository();
    container = makeContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('HomeProvider', () {
    test('initial state is AsyncLoading', () {
      final state = container.read(homeProvider);
      expect(state, isA<AsyncLoading<HomeState>>());
    });

    test('activeHabits contains all active habits', () async {
      final state = await container.read(homeProvider.future);

      expect(state.activeHabits.length, HabitFixtures.initialHabits().length);
    });

    test('completedHabitIds contains habit id logged today', () async {
      final today = DateTime.now();
      final todayLog = HabitLog(
        id: 1,
        habitId: 1,
        date: today,
        points: 30,
        createdAt: today,
      );
      final customContainer = makeContainer(
        historyRepo: MockHistoryRepository(habitLogs: [todayLog]),
      );
      addTearDown(customContainer.dispose);

      final state = await customContainer.read(homeProvider.future);

      expect(state.completedHabitIds, contains(1));
    });

    test('completedHabitIds excludes habit id logged on other day', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final pastLog = HabitLog(
        id: 1,
        habitId: 1,
        date: yesterday,
        points: 30,
        createdAt: yesterday,
      );
      final customContainer = makeContainer(
        historyRepo: MockHistoryRepository(habitLogs: [pastLog]),
      );
      addTearDown(customContainer.dispose);

      final state = await customContainer.read(homeProvider.future);

      expect(state.completedHabitIds, isNot(contains(1)));
    });

    test('topRewards is limited to 3 when more than 3 rewards exist', () async {
      await mockRewardRepo.createReward(title: 'Reward A', targetPoints: 500);
      await mockRewardRepo.createReward(title: 'Reward B', targetPoints: 200);
      await mockRewardRepo.createReward(title: 'Reward C', targetPoints: 100);
      await mockRewardRepo.createReward(title: 'Reward D', targetPoints: 300);

      final state = await container.read(homeProvider.future);

      expect(state.topRewards.length, 3);
    });

    test('topRewards is sorted by targetPoints ascending', () async {
      await mockRewardRepo.createReward(title: 'Expensive', targetPoints: 500);
      await mockRewardRepo.createReward(title: 'Cheap', targetPoints: 100);
      await mockRewardRepo.createReward(title: 'Mid', targetPoints: 300);

      final state = await container.read(homeProvider.future);

      final points =
          state.topRewards.map((r) => r.targetPoints).toList();
      expect(points, [100, 300, 500]);
    });

    test('topRewards returns all rewards when fewer than 3 exist', () async {
      await mockRewardRepo.createReward(title: 'Reward A', targetPoints: 300);
      await mockRewardRepo.createReward(title: 'Reward B', targetPoints: 100);

      final state = await container.read(homeProvider.future);

      expect(state.topRewards.length, 2);
    });
  });
}
