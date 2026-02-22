import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';

void main() {
  final createdAt = DateTime(2024, 1, 1);

  group('Reward', () {
    test('generates instance with required fields', () {
      final reward = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
      );

      expect(reward.id, 1);
      expect(reward.title, 'Coffee');
      expect(reward.targetPoints, 100);
      expect(reward.createdAt, createdAt);
    });

    test('isActive defaults to true', () {
      final reward = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
      );

      expect(reward.isActive, isTrue);
    });

    test('nullable fields default to null', () {
      final reward = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
      );

      expect(reward.imageUri, isNull);
      expect(reward.category, isNull);
      expect(reward.memo, isNull);
    });

    test('copyWith changes specified fields', () {
      final reward = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
      );

      final updated = reward.copyWith(
        title: 'Cake',
        category: RewardCategory.food,
        isActive: false,
      );

      expect(updated.title, 'Cake');
      expect(updated.category, RewardCategory.food);
      expect(updated.isActive, isFalse);
      expect(updated.id, reward.id);
    });

    test('equality holds for identical instances', () {
      final a = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
      );
      final b = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
      );

      expect(a, equals(b));
    });

    test('JSON round-trip restores original values', () {
      final reward = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
        category: RewardCategory.food,
        memo: 'A treat',
      );

      final restored = Reward.fromJson(reward.toJson());

      expect(restored, equals(reward));
    });

    test('nullable fields can be set and retrieved', () {
      final reward = Reward(
        id: 1,
        title: 'Coffee',
        targetPoints: 100,
        createdAt: createdAt,
        imageUri: 'https://example.com/coffee.png',
        category: RewardCategory.food,
        memo: 'Morning treat',
      );

      expect(reward.imageUri, 'https://example.com/coffee.png');
      expect(reward.category, RewardCategory.food);
      expect(reward.memo, 'Morning treat');
    });
  });
}
