import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/notification/domain/models/notification_schedule.dart';

void main() {
  final scheduledTime = DateTime(2026, 2, 1, 8);

  group('NotificationSchedule', () {
    test('generates instance with required fields', () {
      final schedule = NotificationSchedule(
        id: 1,
        habitId: 1,
        habitTitle: '読書 30分',
        scheduledTime: scheduledTime,
      );

      expect(schedule.id, 1);
      expect(schedule.habitId, 1);
      expect(schedule.habitTitle, '読書 30分');
      expect(schedule.scheduledTime, scheduledTime);
    });

    test('copyWith changes specified fields', () {
      final schedule = NotificationSchedule(
        id: 1,
        habitId: 1,
        habitTitle: '読書 30分',
        scheduledTime: scheduledTime,
      );

      final newTime = DateTime(2026, 3, 1, 9);
      final updated = schedule.copyWith(
        habitTitle: 'ランニング',
        scheduledTime: newTime,
      );

      expect(updated.habitTitle, 'ランニング');
      expect(updated.scheduledTime, newTime);
      expect(updated.id, schedule.id);
      expect(updated.habitId, schedule.habitId);
    });

    test('equality compares all fields', () {
      final schedule1 = NotificationSchedule(
        id: 1,
        habitId: 1,
        habitTitle: '読書 30分',
        scheduledTime: scheduledTime,
      );
      final schedule2 = NotificationSchedule(
        id: 1,
        habitId: 1,
        habitTitle: '読書 30分',
        scheduledTime: scheduledTime,
      );

      expect(schedule1, equals(schedule2));
    });

    test('JSON round-trip restores original values', () {
      final schedule = NotificationSchedule(
        id: 1,
        habitId: 1,
        habitTitle: '読書 30分',
        scheduledTime: scheduledTime,
      );

      final restored = NotificationSchedule.fromJson(schedule.toJson());

      expect(restored, equals(schedule));
    });
  });
}
