import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/notification/domain/repositories/notification_repository.dart';
import 'package:hobica/mocks/mock_notification_repository.dart';

void main() {
  group('NotificationRepository', () {
    test('MockNotificationRepository implements NotificationRepository', () {
      final repository = MockNotificationRepository();
      expect(repository, isA<NotificationRepository>());
    });
  });
}
