import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/wallet/domain/models/wallet.dart';

void main() {
  final updatedAt = DateTime(2024, 1, 1);

  group('Wallet', () {
    test('generates instance with required fields', () {
      final wallet = Wallet(id: 1, updatedAt: updatedAt);

      expect(wallet.id, 1);
      expect(wallet.updatedAt, updatedAt);
    });

    test('currentPoints defaults to 0', () {
      final wallet = Wallet(id: 1, updatedAt: updatedAt);

      expect(wallet.currentPoints, 0);
    });

    test('copyWith changes specified fields', () {
      final wallet = Wallet(id: 1, updatedAt: updatedAt);

      final updated = wallet.copyWith(currentPoints: 500);

      expect(updated.currentPoints, 500);
      expect(updated.id, wallet.id);
    });

    test('equality holds for identical instances', () {
      final a = Wallet(id: 1, updatedAt: updatedAt);
      final b = Wallet(id: 1, updatedAt: updatedAt);

      expect(a, equals(b));
    });

    test('JSON round-trip restores original values', () {
      final wallet = Wallet(id: 1, currentPoints: 250, updatedAt: updatedAt);

      final restored = Wallet.fromJson(wallet.toJson());

      expect(restored, equals(wallet));
    });

    // ドメイン上の制約なし: currentPoints にバリデーションは存在しない
    test('accepts negative currentPoints (no domain constraint)', () {
      final wallet = Wallet(id: 1, currentPoints: -100, updatedAt: updatedAt);

      expect(wallet.currentPoints, -100);
    });
  });
}
