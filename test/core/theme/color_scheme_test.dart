import 'package:flutter/material.dart' show Brightness;
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/theme/color_scheme.dart';

void main() {
  group('AppColorSchemes', () {
    test('light() は Brightness.light のカラースキームを返す', () {
      final scheme = AppColorSchemes.light();
      expect(scheme.brightness, Brightness.light);
    });

    test('dark() は Brightness.dark のカラースキームを返す', () {
      final scheme = AppColorSchemes.dark();
      expect(scheme.brightness, Brightness.dark);
    });

    test('light() と dark() は異なるカラースキームを返す', () {
      final light = AppColorSchemes.light();
      final dark = AppColorSchemes.dark();
      expect(light.background, isNot(equals(dark.background)));
    });

    test('light() は必須カラーを全て持つ', () {
      final scheme = AppColorSchemes.light();
      expect(scheme.background, isNotNull);
      expect(scheme.foreground, isNotNull);
      expect(scheme.primary, isNotNull);
      expect(scheme.primaryForeground, isNotNull);
      expect(scheme.secondary, isNotNull);
      expect(scheme.destructive, isNotNull);
    });

    test('dark() は必須カラーを全て持つ', () {
      final scheme = AppColorSchemes.dark();
      expect(scheme.background, isNotNull);
      expect(scheme.foreground, isNotNull);
      expect(scheme.primary, isNotNull);
      expect(scheme.primaryForeground, isNotNull);
      expect(scheme.secondary, isNotNull);
      expect(scheme.destructive, isNotNull);
    });
  });
}
