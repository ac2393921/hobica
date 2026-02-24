import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/home/presentation/providers/home_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';

ProviderContainer _makeContainer({
  MockHabitRepository? habitRepo,
  MockRewardRepository? rewardRepo,
}) {
  return ProviderContainer(
    overrides: [
      habitRepositoryProvider.overrideWithValue(
        habitRepo ?? MockHabitRepository(),
      ),
      rewardRepositoryProvider.overrideWithValue(
        rewardRepo ?? MockRewardRepository(),
      ),
    ],
  );
}

void main() {
  group('HomeProvider', () {
    group('todayHabits', () {
      test('returns all active habits from habitListProvider', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final homeData = await container.read(homeProvider.future);

        // MockHabitRepository starts with 2 active habits (読書 30分, ランニング)
        expect(homeData.todayHabits.length, 2);
      });

      test('returns empty list when no habits exist', () async {
        final emptyHabitRepo = MockHabitRepository();
        final habits = await emptyHabitRepo.fetchAllHabits();
        for (final habit in habits) {
          await emptyHabitRepo.deleteHabit(habit.id);
        }

        final container = _makeContainer(habitRepo: emptyHabitRepo);
        addTearDown(container.dispose);

        final homeData = await container.read(homeProvider.future);

        expect(homeData.todayHabits, isEmpty);
      });
    });

    group('topRewards', () {
      test('returns empty list when no rewards exist', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final homeData = await container.read(homeProvider.future);

        // MockRewardRepository starts empty
        expect(homeData.topRewards, isEmpty);
      });

      test('returns all rewards when 3 or fewer exist', () async {
        final rewardRepo = MockRewardRepository();
        await rewardRepo.createReward(title: 'Reward 1', targetPoints: 100);
        await rewardRepo.createReward(title: 'Reward 2', targetPoints: 200);

        final container = _makeContainer(rewardRepo: rewardRepo);
        addTearDown(container.dispose);

        final homeData = await container.read(homeProvider.future);

        expect(homeData.topRewards.length, 2);
      });

      test('returns at most 3 rewards when more than 3 exist', () async {
        final rewardRepo = MockRewardRepository();
        for (var i = 0; i < 5; i++) {
          await rewardRepo.createReward(
            title: 'Reward $i',
            targetPoints: 100,
          );
        }

        final container = _makeContainer(rewardRepo: rewardRepo);
        addTearDown(container.dispose);

        final homeData = await container.read(homeProvider.future);

        expect(homeData.topRewards.length, 3);
      });

      test('returns first 3 rewards in order when more than 3 exist', () async {
        final rewardRepo = MockRewardRepository();
        for (var i = 1; i <= 5; i++) {
          await rewardRepo.createReward(
            title: 'Reward $i',
            targetPoints: i * 100,
          );
        }

        final container = _makeContainer(rewardRepo: rewardRepo);
        addTearDown(container.dispose);

        final homeData = await container.read(homeProvider.future);

        expect(homeData.topRewards.length, 3);
        expect(homeData.topRewards[0].title, 'Reward 1');
        expect(homeData.topRewards[1].title, 'Reward 2');
        expect(homeData.topRewards[2].title, 'Reward 3');
      });
    });
  });
}
