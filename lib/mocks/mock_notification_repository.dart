import 'package:hobica/features/notification/domain/models/notification_schedule.dart';
import 'package:hobica/features/notification/domain/repositories/notification_repository.dart';
import 'package:hobica/mocks/fixtures.dart';

class MockNotificationRepository implements NotificationRepository {
  MockNotificationRepository() {
    _schedules = [...mockNotificationSchedules];
    _nextId = _schedules.isEmpty
        ? 1
        : _schedules
                .map((schedule) => schedule.id)
                .reduce((a, b) => a > b ? a : b) +
            1;
  }

  List<NotificationSchedule> _schedules = [];
  int _nextId = 1;

  @override
  Future<List<NotificationSchedule>> getScheduledNotifications() async =>
      List.unmodifiable(_schedules);

  @override
  Future<NotificationSchedule> scheduleNotification({
    required int habitId,
    required String habitTitle,
    required DateTime scheduledTime,
  }) async {
    final existingIndex =
        _schedules.indexWhere((schedule) => schedule.habitId == habitId);

    if (existingIndex != -1) {
      final updated = _schedules[existingIndex].copyWith(
        habitTitle: habitTitle,
        scheduledTime: scheduledTime,
      );
      final updatedList = [..._schedules];
      updatedList[existingIndex] = updated;
      _schedules = updatedList;
      return updated;
    }

    final schedule = NotificationSchedule(
      id: _nextId++,
      habitId: habitId,
      habitTitle: habitTitle,
      scheduledTime: scheduledTime,
    );
    _schedules = [..._schedules, schedule];
    return schedule;
  }

  @override
  Future<void> cancelNotification(int habitId) async {
    _schedules = _schedules
        .where((schedule) => schedule.habitId != habitId)
        .toList(growable: false);
  }

  @override
  Future<void> cancelAllNotifications() async {
    _schedules = [];
  }
}
