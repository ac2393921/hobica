import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/theme/typography.dart';

void main() {
  group('AppTypography', () {
    test('geist は Typography インスタンスを返す', () {
      final typography = AppTypography.geist;
      expect(typography, isNotNull);
    });

    test('geist はセマンティックスタイルを持つ', () {
      final typography = AppTypography.geist;
      expect(typography.h1, isNotNull);
      expect(typography.h2, isNotNull);
      expect(typography.h3, isNotNull);
      expect(typography.p, isNotNull);
    });

    test('geist はサイズスタイルを持つ', () {
      final typography = AppTypography.geist;
      expect(typography.small, isNotNull);
      expect(typography.base, isNotNull);
      expect(typography.large, isNotNull);
      expect(typography.x2Large, isNotNull);
    });
  });
}
