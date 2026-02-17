import 'package:flutter/material.dart' show Brightness;
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    group('light', () {
      test('ライトモード用 ThemeData を返す', () {
        final theme = AppTheme.light;
        expect(theme, isNotNull);
        expect(theme.colorScheme.brightness, Brightness.light);
      });

      test('radius が設定されている', () {
        final theme = AppTheme.light;
        expect(theme.radius, 0.5);
      });

      test('typography が設定されている', () {
        final theme = AppTheme.light;
        expect(theme.typography, isNotNull);
      });
    });

    group('dark', () {
      test('ダークモード用 ThemeData を返す', () {
        final theme = AppTheme.dark;
        expect(theme, isNotNull);
        expect(theme.colorScheme.brightness, Brightness.dark);
      });

      test('radius が設定されている', () {
        final theme = AppTheme.dark;
        expect(theme.radius, 0.5);
      });

      test('typography が設定されている', () {
        final theme = AppTheme.dark;
        expect(theme.typography, isNotNull);
      });
    });

    test('light と dark は異なるカラースキームを持つ', () {
      final light = AppTheme.light;
      final dark = AppTheme.dark;
      expect(
        light.colorScheme.background,
        isNot(equals(dark.colorScheme.background)),
      );
    });

    test('light と dark は同じ radius を持つ', () {
      expect(AppTheme.light.radius, AppTheme.dark.radius);
    });
  });
}
