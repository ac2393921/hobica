import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/notification/presentation/providers/notification_provider.dart';
import 'package:hobica/mocks/mock_notification_repository.dart';

ProviderContainer _makeContainer() {
  return ProviderContainer(
    overrides: [
      notificationRepositoryProvider
          .overrideWithValue(MockNotificationRepository()),
    ],
  );
}

void main() {
  group('notificationRepositoryProvider', () {
    test('throws UnimplementedError without override', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(notificationRepositoryProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('NotificationNotifier', () {
    group('build', () {
      test('loads initial scheduled notifications', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final schedules =
            await container.read(notificationNotifierProvider.future);

        expect(schedules.length, 1);
        expect(schedules.first.habitId, 1);
        expect(schedules.first.habitTitle, '読書 30分');
      });
    });

    group('scheduleNotification', () {
      test('adds new schedule and refreshes state', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(notificationNotifierProvider.future);

        await container
            .read(notificationNotifierProvider.notifier)
            .scheduleNotification(
              habitId: 2,
              habitTitle: 'ランニング',
              scheduledTime: DateTime(2026, 3, 1, 7),
            );

        final schedules =
            await container.read(notificationNotifierProvider.future);
        expect(schedules.length, 2);
      });

      test('updates existing schedule for same habitId', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(notificationNotifierProvider.future);

        await container
            .read(notificationNotifierProvider.notifier)
            .scheduleNotification(
              habitId: 1,
              habitTitle: '読書 1時間',
              scheduledTime: DateTime(2026, 3, 1, 10),
            );

        final schedules =
            await container.read(notificationNotifierProvider.future);
        expect(schedules.length, 1);
        expect(schedules.first.habitTitle, '読書 1時間');
      });
    });

    group('cancelNotification', () {
      test('removes schedule and refreshes state', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(notificationNotifierProvider.future);

        await container
            .read(notificationNotifierProvider.notifier)
            .cancelNotification(1);

        final schedules =
            await container.read(notificationNotifierProvider.future);
        expect(schedules, isEmpty);
      });
    });

    group('cancelAllNotifications', () {
      test('removes all schedules and refreshes state', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(notificationNotifierProvider.future);

        await container
            .read(notificationNotifierProvider.notifier)
            .scheduleNotification(
              habitId: 2,
              habitTitle: 'ランニング',
              scheduledTime: DateTime(2026, 3, 1, 7),
            );

        await container
            .read(notificationNotifierProvider.notifier)
            .cancelAllNotifications();

        final schedules =
            await container.read(notificationNotifierProvider.future);
        expect(schedules, isEmpty);
      });
    });
  });
}
