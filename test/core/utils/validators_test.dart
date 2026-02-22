import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateTitle', () {
      test('null → エラーメッセージ（非null の String）', () {
        final result = Validators.validateTitle(null);
        expect(result, isNotNull);
        expect(result, isA<String>());
      });

      test('空文字 → エラーメッセージ', () {
        final result = Validators.validateTitle('');
        expect(result, isNotNull);
      });

      test('1文字 → null（有効）', () {
        final result = Validators.validateTitle('a');
        expect(result, isNull);
      });

      test('50文字 → null（有効）', () {
        final result = Validators.validateTitle('a' * 50);
        expect(result, isNull);
      });

      test('51文字 → エラーメッセージ', () {
        final result = Validators.validateTitle('a' * 51);
        expect(result, isNotNull);
      });

      test('空白のみ文字列 → エラーメッセージ', () {
        final result = Validators.validateTitle('   ');
        expect(result, isNotNull);
      });
    });

    group('validatePoints', () {
      test('null → エラーメッセージ', () {
        final result = Validators.validatePoints(null);
        expect(result, isNotNull);
        expect(result, isA<String>());
      });

      test('空文字 → エラーメッセージ', () {
        final result = Validators.validatePoints('');
        expect(result, isNotNull);
      });

      test('"1" → null（有効）', () {
        final result = Validators.validatePoints('1');
        expect(result, isNull);
      });

      test('"0" → エラーメッセージ（1未満）', () {
        final result = Validators.validatePoints('0');
        expect(result, isNotNull);
      });

      test('"-1" → エラーメッセージ', () {
        final result = Validators.validatePoints('-1');
        expect(result, isNotNull);
      });

      test('"abc" → エラーメッセージ（非整数）', () {
        final result = Validators.validatePoints('abc');
        expect(result, isNotNull);
      });

      test('"1.5" → エラーメッセージ（小数は無効）', () {
        final result = Validators.validatePoints('1.5');
        expect(result, isNotNull);
      });

      test('十分に大きな整数 → null（有効）', () {
        final result = Validators.validatePoints('1000000');
        expect(result, isNull);
      });
    });
  });
}
