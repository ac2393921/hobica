import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/monetization/domain/models/premium_status.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';

// DateTime.now() ではなく固定値にすることでテストの再現性を保証する
final _baseDate = DateTime(2026, 2);

final mockHabits = List<Habit>.unmodifiable([
  Habit(
    id: 1,
    title: '読書 30分',
    points: 30,
    frequencyType: FrequencyType.daily,
    frequencyValue: 1,
    remindTime: DateTime(2026, 2, 1, 8),
    createdAt: _baseDate,
  ),
  Habit(
    id: 2,
    title: 'ランニング',
    points: 50,
    frequencyType: FrequencyType.weekly,
    frequencyValue: 3,
    createdAt: _baseDate,
  ),
  Habit(
    id: 3,
    title: '週次レビュー',
    points: 20,
    frequencyType: FrequencyType.weekly,
    frequencyValue: 1,
    createdAt: _baseDate,
    isActive: false,
  ),
]);

final mockHabitLogs = List<HabitLog>.unmodifiable([
  HabitLog(
    id: 1,
    habitId: 1,
    date: DateTime(2026, 2, 20),
    points: 30,
    createdAt: DateTime(2026, 2, 20),
  ),
  HabitLog(
    id: 2,
    habitId: 2,
    date: DateTime(2026, 2, 21),
    points: 50,
    createdAt: DateTime(2026, 2, 21),
  ),
]);

final mockRewards = List<Reward>.unmodifiable([
  Reward(
    id: 1,
    title: '好きなスイーツ',
    targetPoints: 100,
    category: RewardCategory.food,
    createdAt: _baseDate,
  ),
  Reward(
    id: 2,
    title: '映画鑑賞',
    targetPoints: 200,
    category: RewardCategory.entertainment,
    memo: '好きな映画を1本見る',
    createdAt: _baseDate,
  ),
  Reward(
    id: 3,
    title: '新しい本を購入',
    targetPoints: 150,
    category: RewardCategory.item,
    createdAt: _baseDate,
  ),
]);

final mockRedemptions = List<RewardRedemption>.unmodifiable([
  RewardRedemption(id: 1, rewardId: 1, pointsSpent: 100, redeemedAt: _baseDate),
]);

final mockWallet = Wallet(id: 1, currentPoints: 250, updatedAt: _baseDate);

final mockAppSettings = AppSettings(
  id: 1,
  themeMode: AppThemeMode.system,
  notificationsEnabled: true,
  locale: 'ja',
  updatedAt: _baseDate,
);

final mockPremiumStatus = PremiumStatus(
  id: 1,
  isPremium: false,
  updatedAt: _baseDate,
);

class HabitFixtures {
  HabitFixtures._();

  static List<Habit> initialHabits() =>
      mockHabits.where((habit) => habit.isActive).toList(growable: false);
}
