import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';

void main() {
  final createdAt = DateTime(2024, 1, 1);

  group('Habit', () {
    test('generates instance with required fields', () {
      final habit = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
      );

      expect(habit.id, 1);
      expect(habit.title, 'Morning Run');
      expect(habit.points, 10);
      expect(habit.frequencyType, FrequencyType.daily);
      expect(habit.frequencyValue, 1);
      expect(habit.createdAt, createdAt);
    });

    test('isActive defaults to true', () {
      final habit = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
      );

      expect(habit.isActive, isTrue);
    });

    test('remindTime defaults to null', () {
      final habit = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
      );

      expect(habit.remindTime, isNull);
    });

    test('copyWith changes specified fields', () {
      final habit = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
      );

      final updated = habit.copyWith(title: 'Evening Run', isActive: false);

      expect(updated.title, 'Evening Run');
      expect(updated.isActive, isFalse);
      expect(updated.id, habit.id);
      expect(updated.points, habit.points);
    });

    test('equality holds for identical instances', () {
      final a = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
      );
      final b = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
      );

      expect(a, equals(b));
    });

    test('JSON round-trip restores original values', () {
      final habit = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
        isActive: false,
      );

      final restored = Habit.fromJson(habit.toJson());

      expect(restored, equals(habit));
    });

    test('nullable remindTime can be set and retrieved', () {
      final remindTime = DateTime(2024, 6, 1, 8, 0);
      final habit = Habit(
        id: 1,
        title: 'Morning Run',
        points: 10,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: createdAt,
        remindTime: remindTime,
      );

      expect(habit.remindTime, remindTime);
    });

    // ドメイン上の制約なし: points / frequencyValue にバリデーションは存在しない
    test('accepts zero for points and frequencyValue (no domain constraint)', () {
      final habit = Habit(
        id: 1,
        title: 'Test',
        points: 0,
        frequencyType: FrequencyType.daily,
        frequencyValue: 0,
        createdAt: createdAt,
      );

      expect(habit.points, 0);
      expect(habit.frequencyValue, 0);
    });

    test('accepts negative values for points and frequencyValue (no domain constraint)', () {
      final habit = Habit(
        id: 1,
        title: 'Test',
        points: -1,
        frequencyType: FrequencyType.weekly,
        frequencyValue: -1,
        createdAt: createdAt,
      );

      expect(habit.points, -1);
      expect(habit.frequencyValue, -1);
    });
  });
}
