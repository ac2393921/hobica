import 'package:hobica/core/utils/date_utils.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

class HomeState {
  const HomeState({
    required this.activeHabits,
    required this.completedHabitIds,
    required this.topRewards,
  });

  final List<Habit> activeHabits;
  final Set<int> completedHabitIds;
  final List<Reward> topRewards;
}

@riverpod
class Home extends _$Home {
  @override
  Future<HomeState> build() async {
    final habitRepo = ref.watch(habitRepositoryProvider);
    final historyRepo = ref.watch(historyRepositoryProvider);
    final rewardRepo = ref.watch(rewardRepositoryProvider);

    final habits = await habitRepo.fetchAllHabits();
    final logs = await historyRepo.fetchHabitLogs();
    final allRewards = await rewardRepo.fetchAllRewards();

    final today = DateTime.now().toDate();

    final completedHabitIds = logs
        .where((log) => log.date.toDate() == today)
        .map((log) => log.habitId)
        .toSet();

    final topRewards = (allRewards.toList()
          ..sort((a, b) => a.targetPoints.compareTo(b.targetPoints)))
        .take(3)
        .toList();

    return HomeState(
      activeHabits: habits,
      completedHabitIds: completedHabitIds,
      topRewards: topRewards,
    );
  }
}
