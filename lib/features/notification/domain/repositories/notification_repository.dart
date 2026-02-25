import 'package:hobica/features/notification/domain/models/notification_schedule.dart';

abstract interface class NotificationRepository {
  Future<List<NotificationSchedule>> getScheduledNotifications();

  Future<NotificationSchedule> scheduleNotification({
    required int habitId,
    required String habitTitle,
    required DateTime scheduledTime,
  });

  Future<void> cancelNotification(int habitId);

  Future<void> cancelAllNotifications();
}
