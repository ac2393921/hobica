import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';

void main() {
  group('Result', () {
    group('コンストラクタ', () {
      test('Result.success で Success インスタンスを生成できる', () {
        const result = Result<int, AppError>.success(42);
        expect(result, isA<Success<int, AppError>>());
      });

      test('Result.failure で Failure インスタンスを生成できる', () {
        const result = Result<int, AppError>.failure(
          AppError.validation('エラー'),
        );
        expect(result, isA<Failure<int, AppError>>());
      });
    });

    group('value / error プロパティ', () {
      test('Success の value を保持する', () {
        const result = Result<String, AppError>.success('テスト');
        expect((result as Success<String, AppError>).value, 'テスト');
      });

      test('Failure の error を保持する', () {
        const appError = AppError.notFound('見つかりません');
        const result = Result<String, AppError>.failure(appError);
        expect((result as Failure<String, AppError>).error, appError);
      });
    });

    group('when パターンマッチング', () {
      test('Success の when が success ハンドラを呼ぶ', () {
        const result = Result<int, AppError>.success(10);
        final output = result.when(
          success: (value) => 'success: $value',
          failure: (error) => 'failure',
        );
        expect(output, 'success: 10');
      });

      test('Failure の when が failure ハンドラを呼ぶ', () {
        const result = Result<int, AppError>.failure(
          AppError.validation('バリデーションエラー'),
        );
        final output = result.when(
          success: (value) => 'success',
          failure: (error) => error.when(
            validation: (msg) => 'validation: $msg',
            notFound: (msg) => 'notFound',
            alreadyCompleted: (msg) => 'alreadyCompleted',
            insufficientPoints: (msg) => 'insufficientPoints',
            unknown: (msg) => 'unknown',
          ),
        );
        expect(output, 'validation: バリデーションエラー');
      });
    });

    group('maybeWhen パターンマッチング', () {
      test('Success の maybeWhen で success ケースに一致する', () {
        const result = Result<int, AppError>.success(5);
        final output = result.maybeWhen(
          success: (value) => 'matched: $value',
          orElse: () => 'orElse',
        );
        expect(output, 'matched: 5');
      });

      test('Failure の maybeWhen で orElse を呼ぶ（success のみ指定）', () {
        const result = Result<int, AppError>.failure(AppError.unknown('エラー'));
        final output = result.maybeWhen(
          success: (value) => 'matched',
          orElse: () => 'orElse called',
        );
        expect(output, 'orElse called');
      });
    });

    group('型パラメータ', () {
      test('Result<String, AppError> が正しく動作する', () {
        const result = Result<String, AppError>.success('文字列');
        expect((result as Success<String, AppError>).value, '文字列');
      });

      test('Result<List<int>, AppError> が正しく動作する', () {
        const result = Result<List<int>, AppError>.success([1, 2, 3]);
        expect((result as Success<List<int>, AppError>).value, [1, 2, 3]);
      });

      test('Result<void, AppError> の success で null を扱える', () {
        const result = Result<void, AppError>.success(null);
        expect(result, isA<Success<void, AppError>>());
        // void 型の value は使用できないため、isA チェックのみ
        result.when(
          success: (_) {},
          failure: (error) => fail('should be success'),
        );
      });

      test('Result<int, AppError> の failure で AppError を扱える', () {
        const appError = AppError.insufficientPoints('ポイント不足');
        const result = Result<int, AppError>.failure(appError);
        result.when(
          success: (value) => fail('should be failure'),
          failure: (error) => expect(
            error,
            isA<InsufficientPointsError>(),
          ),
        );
      });
    });

    group('等価性', () {
      test('同じ value の Success は等価', () {
        const r1 = Result<int, AppError>.success(42);
        const r2 = Result<int, AppError>.success(42);
        expect(r1, equals(r2));
      });

      test('異なる value の Success は非等価', () {
        const r1 = Result<int, AppError>.success(1);
        const r2 = Result<int, AppError>.success(2);
        expect(r1, isNot(equals(r2)));
      });

      test('同じ error の Failure は等価', () {
        const r1 = Result<int, AppError>.failure(AppError.unknown('エラー'));
        const r2 = Result<int, AppError>.failure(AppError.unknown('エラー'));
        expect(r1, equals(r2));
      });

      test('Success と Failure は非等価', () {
        const r1 = Result<int, AppError>.success(1);
        const r2 = Result<int, AppError>.failure(AppError.unknown('エラー'));
        expect(r1, isNot(equals(r2)));
      });
    });
  });
}
