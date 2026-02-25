import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/mocks/mock_notification_repository.dart';

void main() {
  late MockNotificationRepository repository;

  setUp(() {
    repository = MockNotificationRepository();
  });

  group('MockNotificationRepository', () {
    group('getScheduledNotifications', () {
      test('returns initial fixture data', () async {
        final schedules = await repository.getScheduledNotifications();

        expect(schedules.length, 1);
        expect(schedules.first.habitId, 1);
        expect(schedules.first.habitTitle, '読書 30分');
      });
    });

    group('scheduleNotification', () {
      test('adds new schedule for new habitId', () async {
        final scheduledTime = DateTime(2026, 3, 1, 9);

        final schedule = await repository.scheduleNotification(
          habitId: 2,
          habitTitle: 'ランニング',
          scheduledTime: scheduledTime,
        );

        expect(schedule.habitId, 2);
        expect(schedule.habitTitle, 'ランニング');
        expect(schedule.scheduledTime, scheduledTime);

        final all = await repository.getScheduledNotifications();
        expect(all.length, 2);
      });

      test('updates existing schedule for same habitId (upsert)', () async {
        final newTime = DateTime(2026, 3, 1, 10);

        final updated = await repository.scheduleNotification(
          habitId: 1,
          habitTitle: '読書 1時間',
          scheduledTime: newTime,
        );

        expect(updated.habitId, 1);
        expect(updated.habitTitle, '読書 1時間');
        expect(updated.scheduledTime, newTime);

        final all = await repository.getScheduledNotifications();
        expect(all.length, 1);
      });

      test('assigns unique IDs to new schedules', () async {
        final schedule1 = await repository.scheduleNotification(
          habitId: 2,
          habitTitle: 'ランニング',
          scheduledTime: DateTime(2026, 3, 1, 7),
        );
        final schedule2 = await repository.scheduleNotification(
          habitId: 3,
          habitTitle: '週次レビュー',
          scheduledTime: DateTime(2026, 3, 1, 18),
        );

        expect(schedule1.id, isNot(equals(schedule2.id)));
      });
    });

    group('cancelNotification', () {
      test('removes schedule for specified habitId', () async {
        await repository.cancelNotification(1);

        final schedules = await repository.getScheduledNotifications();
        expect(schedules, isEmpty);
      });

      test('does not affect other schedules', () async {
        await repository.scheduleNotification(
          habitId: 2,
          habitTitle: 'ランニング',
          scheduledTime: DateTime(2026, 3, 1, 7),
        );

        await repository.cancelNotification(1);

        final schedules = await repository.getScheduledNotifications();
        expect(schedules.length, 1);
        expect(schedules.first.habitId, 2);
      });

      test('no-op when habitId does not exist', () async {
        await repository.cancelNotification(999);

        final schedules = await repository.getScheduledNotifications();
        expect(schedules.length, 1);
      });
    });

    group('cancelAllNotifications', () {
      test('removes all schedules', () async {
        await repository.scheduleNotification(
          habitId: 2,
          habitTitle: 'ランニング',
          scheduledTime: DateTime(2026, 3, 1, 7),
        );

        await repository.cancelAllNotifications();

        final schedules = await repository.getScheduledNotifications();
        expect(schedules, isEmpty);
      });
    });
  });
}
