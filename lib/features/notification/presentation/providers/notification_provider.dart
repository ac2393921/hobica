import 'package:hobica/features/notification/domain/models/notification_schedule.dart';
import 'package:hobica/features/notification/domain/repositories/notification_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  throw UnimplementedError('notificationRepository must be overridden');
}

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  Future<List<NotificationSchedule>> build() async {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.getScheduledNotifications();
  }

  Future<void> scheduleNotification({
    required int habitId,
    required String habitTitle,
    required DateTime scheduledTime,
  }) async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.scheduleNotification(
      habitId: habitId,
      habitTitle: habitTitle,
      scheduledTime: scheduledTime,
    );
    ref.invalidateSelf();
  }

  Future<void> cancelNotification(int habitId) async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.cancelNotification(habitId);
    ref.invalidateSelf();
  }

  Future<void> cancelAllNotifications() async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.cancelAllNotifications();
    ref.invalidateSelf();
  }
}
