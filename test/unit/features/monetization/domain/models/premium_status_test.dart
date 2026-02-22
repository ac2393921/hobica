import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/monetization/domain/models/premium_status.dart';

void main() {
  final updatedAt = DateTime(2024, 1, 1);

  group('PremiumStatus', () {
    test('generates instance with required fields', () {
      final status = PremiumStatus(id: 1, updatedAt: updatedAt);

      expect(status.id, 1);
      expect(status.updatedAt, updatedAt);
    });

    test('isPremium defaults to false', () {
      final status = PremiumStatus(id: 1, updatedAt: updatedAt);

      expect(status.isPremium, isFalse);
    });

    test('nullable fields default to null', () {
      final status = PremiumStatus(id: 1, updatedAt: updatedAt);

      expect(status.premiumExpiresAt, isNull);
      expect(status.purchaseToken, isNull);
    });

    test('copyWith changes specified fields', () {
      final status = PremiumStatus(id: 1, updatedAt: updatedAt);
      final expiresAt = DateTime(2025, 1, 1);

      final updated = status.copyWith(
        isPremium: true,
        premiumExpiresAt: expiresAt,
        purchaseToken: 'token-abc',
      );

      expect(updated.isPremium, isTrue);
      expect(updated.premiumExpiresAt, expiresAt);
      expect(updated.purchaseToken, 'token-abc');
      expect(updated.id, status.id);
    });

    test('equality holds for identical instances', () {
      final a = PremiumStatus(id: 1, updatedAt: updatedAt);
      final b = PremiumStatus(id: 1, updatedAt: updatedAt);

      expect(a, equals(b));
    });

    test('JSON round-trip restores original values', () {
      final expiresAt = DateTime(2025, 6, 1);
      final status = PremiumStatus(
        id: 1,
        isPremium: true,
        premiumExpiresAt: expiresAt,
        purchaseToken: 'token-xyz',
        updatedAt: updatedAt,
      );

      final restored = PremiumStatus.fromJson(status.toJson());

      expect(restored, equals(status));
    });

    test('nullable premiumExpiresAt can be set and retrieved', () {
      final expiresAt = DateTime(2025, 12, 31);
      final status = PremiumStatus(
        id: 1,
        isPremium: true,
        premiumExpiresAt: expiresAt,
        updatedAt: updatedAt,
      );

      expect(status.premiumExpiresAt, expiresAt);
    });

    // ドメイン上有効な状態: isPremium=true かつ purchaseToken=null は許容される
    // (手動付与・生涯プラン等でトークンが存在しないケースを想定)
    test('isPremium can be true without purchaseToken (e.g. manual grant)', () {
      final status = PremiumStatus(
        id: 1,
        isPremium: true,
        updatedAt: updatedAt,
      );

      expect(status.isPremium, isTrue);
      expect(status.purchaseToken, isNull);
    });
  });
}
