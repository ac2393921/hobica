import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';

void main() {
  final date = DateTime(2024, 1, 15);
  final createdAt = DateTime(2024, 1, 15, 10, 0);

  group('HabitLog', () {
    test('generates instance with required fields', () {
      final log = HabitLog(
        id: 1,
        habitId: 42,
        date: date,
        points: 10,
        createdAt: createdAt,
      );

      expect(log.id, 1);
      expect(log.habitId, 42);
      expect(log.date, date);
      expect(log.points, 10);
      expect(log.createdAt, createdAt);
    });

    test('copyWith changes specified fields', () {
      final log = HabitLog(
        id: 1,
        habitId: 42,
        date: date,
        points: 10,
        createdAt: createdAt,
      );

      final updated = log.copyWith(points: 20);

      expect(updated.points, 20);
      expect(updated.id, log.id);
      expect(updated.habitId, log.habitId);
    });

    test('equality holds for identical instances', () {
      final a = HabitLog(
        id: 1,
        habitId: 42,
        date: date,
        points: 10,
        createdAt: createdAt,
      );
      final b = HabitLog(
        id: 1,
        habitId: 42,
        date: date,
        points: 10,
        createdAt: createdAt,
      );

      expect(a, equals(b));
    });

    test('JSON round-trip restores original values', () {
      final log = HabitLog(
        id: 1,
        habitId: 42,
        date: date,
        points: 10,
        createdAt: createdAt,
      );

      final restored = HabitLog.fromJson(log.toJson());

      expect(restored, equals(log));
    });
  });
}
