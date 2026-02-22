import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

void main() {
  final redeemedAt = DateTime(2024, 6, 15, 12, 0);

  group('RewardRedemption', () {
    test('generates instance with required fields', () {
      final redemption = RewardRedemption(
        id: 1,
        rewardId: 10,
        pointsSpent: 100,
        redeemedAt: redeemedAt,
      );

      expect(redemption.id, 1);
      expect(redemption.rewardId, 10);
      expect(redemption.pointsSpent, 100);
      expect(redemption.redeemedAt, redeemedAt);
    });

    test('copyWith changes specified fields', () {
      final redemption = RewardRedemption(
        id: 1,
        rewardId: 10,
        pointsSpent: 100,
        redeemedAt: redeemedAt,
      );

      final updated = redemption.copyWith(pointsSpent: 200);

      expect(updated.pointsSpent, 200);
      expect(updated.id, redemption.id);
      expect(updated.rewardId, redemption.rewardId);
    });

    test('equality holds for identical instances', () {
      final a = RewardRedemption(
        id: 1,
        rewardId: 10,
        pointsSpent: 100,
        redeemedAt: redeemedAt,
      );
      final b = RewardRedemption(
        id: 1,
        rewardId: 10,
        pointsSpent: 100,
        redeemedAt: redeemedAt,
      );

      expect(a, equals(b));
    });

    test('JSON round-trip restores original values', () {
      final redemption = RewardRedemption(
        id: 1,
        rewardId: 10,
        pointsSpent: 100,
        redeemedAt: redeemedAt,
      );

      final restored = RewardRedemption.fromJson(redemption.toJson());

      expect(restored, equals(redemption));
    });
  });
}
