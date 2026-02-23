import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/mocks/fixtures.dart';

void main() {
  group('mockHabits', () {
    test('contains 3 entries', () {
      expect(mockHabits.length, 3);
    });

    test('first entry has expected fields', () {
      final habit = mockHabits[0];
      expect(habit.id, 1);
      expect(habit.title, '読書 30分');
      expect(habit.points, 30);
      expect(habit.frequencyType, FrequencyType.daily);
      expect(habit.frequencyValue, 1);
      expect(habit.remindTime, isNotNull);
      expect(habit.isActive, isTrue);
    });

    test('second entry is weekly habit', () {
      final habit = mockHabits[1];
      expect(habit.id, 2);
      expect(habit.frequencyType, FrequencyType.weekly);
      expect(habit.frequencyValue, 3);
      expect(habit.remindTime, isNull);
      expect(habit.isActive, isTrue);
    });

    test('third entry is inactive', () {
      final habit = mockHabits[2];
      expect(habit.id, 3);
      expect(habit.isActive, isFalse);
    });
  });

  group('mockHabitLogs', () {
    test('contains 2 entries', () {
      expect(mockHabitLogs.length, 2);
    });

    test('first log references first habit', () {
      final log = mockHabitLogs[0];
      expect(log.id, 1);
      expect(log.habitId, 1);
      expect(log.points, 30);
      expect(log.date, DateTime(2026, 2, 20));
      expect(log.createdAt, DateTime(2026, 2, 20));
    });

    test('second log references second habit', () {
      final log = mockHabitLogs[1];
      expect(log.id, 2);
      expect(log.habitId, 2);
      expect(log.points, 50);
      expect(log.date, DateTime(2026, 2, 21));
      expect(log.createdAt, DateTime(2026, 2, 21));
    });

    test('entries have distinct dates', () {
      expect(mockHabitLogs[0].date, isNot(equals(mockHabitLogs[1].date)));
    });
  });

  group('mockRewards', () {
    test('contains 3 entries', () {
      expect(mockRewards.length, 3);
    });

    test('first reward is food category', () {
      final reward = mockRewards[0];
      expect(reward.id, 1);
      expect(reward.category, RewardCategory.food);
      expect(reward.targetPoints, 100);
      expect(reward.isActive, isTrue);
    });

    test('second reward has memo', () {
      final reward = mockRewards[1];
      expect(reward.id, 2);
      expect(reward.category, RewardCategory.entertainment);
      expect(reward.memo, isNotNull);
    });

    test('third reward is item category', () {
      final reward = mockRewards[2];
      expect(reward.id, 3);
      expect(reward.category, RewardCategory.item);
    });
  });

  group('mockRedemptions', () {
    test('contains 1 entry', () {
      expect(mockRedemptions.length, 1);
    });

    test('redemption references first reward', () {
      final redemption = mockRedemptions[0];
      expect(redemption.id, 1);
      expect(redemption.rewardId, 1);
      expect(redemption.pointsSpent, 100);
      expect(redemption.redeemedAt, DateTime(2026, 2));
    });
  });

  group('mockWallet', () {
    test('has expected fields', () {
      expect(mockWallet.id, 1);
      expect(mockWallet.currentPoints, 250);
      expect(mockWallet.updatedAt, DateTime(2026, 2));
    });
  });

  group('mockAppSettings', () {
    test('has expected fields', () {
      expect(mockAppSettings.id, 1);
      expect(mockAppSettings.themeMode, AppThemeMode.system);
      expect(mockAppSettings.notificationsEnabled, isTrue);
      expect(mockAppSettings.locale, 'ja');
      expect(mockAppSettings.updatedAt, DateTime(2026, 2));
    });
  });

  group('mockPremiumStatus', () {
    test('has expected fields', () {
      expect(mockPremiumStatus.id, 1);
      expect(mockPremiumStatus.isPremium, isFalse);
      expect(mockPremiumStatus.premiumExpiresAt, isNull);
      expect(mockPremiumStatus.purchaseToken, isNull);
      expect(mockPremiumStatus.updatedAt, DateTime(2026, 2));
    });
  });
}
