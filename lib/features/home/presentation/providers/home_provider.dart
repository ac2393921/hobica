import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

/// ホーム画面に表示するデータの集約クラス。
class HomeData {
  const HomeData({required this.todayHabits, required this.topRewards});

  final List<Habit> todayHabits;
  final List<Reward> topRewards;
}

/// ホーム画面用プロバイダー。
///
/// ウォレット残高は AppBar 常時表示のため HomePage が直接 watch する。
@riverpod
class Home extends _$Home {
  static const _topRewardsLimit = 3;

  @override
  Future<HomeData> build() async {
    final habits = await ref.watch(habitListProvider.future);
    final rewards = await ref.watch(rewardListProvider.future);
    return HomeData(
      todayHabits: habits,
      topRewards: rewards.take(_topRewardsLimit).toList(),
    );
  }
}
