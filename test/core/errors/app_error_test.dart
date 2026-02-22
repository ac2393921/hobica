import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';

void main() {
  group('AppError', () {
    group('コンストラクタ', () {
      test('validation エラーを生成できる', () {
        const error = AppError.validation('入力値が不正です');
        expect(error, isA<ValidationError>());
      });

      test('notFound エラーを生成できる', () {
        const error = AppError.notFound('リソースが見つかりません');
        expect(error, isA<NotFoundError>());
      });

      test('alreadyCompleted エラーを生成できる', () {
        const error = AppError.alreadyCompleted('すでに完了しています');
        expect(error, isA<AlreadyCompletedError>());
      });

      test('insufficientPoints エラーを生成できる', () {
        const error = AppError.insufficientPoints('ポイントが不足しています');
        expect(error, isA<InsufficientPointsError>());
      });

      test('unknown エラーを生成できる', () {
        const error = AppError.unknown('不明なエラーが発生しました');
        expect(error, isA<UnknownError>());
      });
    });

    group('message プロパティ', () {
      test('validation の message を保持する', () {
        const message = '入力値が不正です';
        const error = AppError.validation(message);
        expect((error as ValidationError).message, message);
      });

      test('notFound の message を保持する', () {
        const message = 'リソースが見つかりません';
        const error = AppError.notFound(message);
        expect((error as NotFoundError).message, message);
      });

      test('alreadyCompleted の message を保持する', () {
        const message = 'すでに完了しています';
        const error = AppError.alreadyCompleted(message);
        expect((error as AlreadyCompletedError).message, message);
      });

      test('insufficientPoints の message を保持する', () {
        const message = 'ポイントが不足しています';
        const error = AppError.insufficientPoints(message);
        expect((error as InsufficientPointsError).message, message);
      });

      test('unknown の message を保持する', () {
        const message = '不明なエラーが発生しました';
        const error = AppError.unknown(message);
        expect((error as UnknownError).message, message);
      });
    });

    group('when パターンマッチング', () {
      test('validation の when が正しいケースを呼ぶ', () {
        const error = AppError.validation('エラー');
        final result = error.when(
          validation: (message) => 'validation: $message',
          notFound: (message) => 'notFound: $message',
          alreadyCompleted: (message) => 'alreadyCompleted: $message',
          insufficientPoints: (message) => 'insufficientPoints: $message',
          unknown: (message) => 'unknown: $message',
        );
        expect(result, 'validation: エラー');
      });

      test('notFound の when が正しいケースを呼ぶ', () {
        const error = AppError.notFound('見つかりません');
        final result = error.when(
          validation: (message) => 'validation',
          notFound: (message) => 'notFound: $message',
          alreadyCompleted: (message) => 'alreadyCompleted',
          insufficientPoints: (message) => 'insufficientPoints',
          unknown: (message) => 'unknown',
        );
        expect(result, 'notFound: 見つかりません');
      });

      test('alreadyCompleted の when が正しいケースを呼ぶ', () {
        const error = AppError.alreadyCompleted('完了済み');
        final result = error.when(
          validation: (message) => 'validation',
          notFound: (message) => 'notFound',
          alreadyCompleted: (message) => 'alreadyCompleted: $message',
          insufficientPoints: (message) => 'insufficientPoints',
          unknown: (message) => 'unknown',
        );
        expect(result, 'alreadyCompleted: 完了済み');
      });

      test('insufficientPoints の when が正しいケースを呼ぶ', () {
        const error = AppError.insufficientPoints('ポイント不足');
        final result = error.when(
          validation: (message) => 'validation',
          notFound: (message) => 'notFound',
          alreadyCompleted: (message) => 'alreadyCompleted',
          insufficientPoints: (message) => 'insufficientPoints: $message',
          unknown: (message) => 'unknown',
        );
        expect(result, 'insufficientPoints: ポイント不足');
      });

      test('unknown の when が正しいケースを呼ぶ', () {
        const error = AppError.unknown('不明エラー');
        final result = error.when(
          validation: (message) => 'validation',
          notFound: (message) => 'notFound',
          alreadyCompleted: (message) => 'alreadyCompleted',
          insufficientPoints: (message) => 'insufficientPoints',
          unknown: (message) => 'unknown: $message',
        );
        expect(result, 'unknown: 不明エラー');
      });
    });

    group('maybeWhen パターンマッチング', () {
      test('maybeWhen で一致するケースのみ処理する', () {
        const error = AppError.validation('エラー');
        final result = error.maybeWhen(
          validation: (message) => 'matched: $message',
          orElse: () => 'not matched',
        );
        expect(result, 'matched: エラー');
      });

      test('maybeWhen で一致しない場合は orElse を呼ぶ', () {
        const error = AppError.notFound('見つかりません');
        final result = error.maybeWhen(
          validation: (message) => 'matched',
          orElse: () => 'orElse called',
        );
        expect(result, 'orElse called');
      });
    });

    group('等価性', () {
      test('同じ型・同じ message は等価', () {
        const error1 = AppError.validation('同じメッセージ');
        const error2 = AppError.validation('同じメッセージ');
        expect(error1, equals(error2));
      });

      test('同じ型でも異なる message は非等価', () {
        const error1 = AppError.validation('メッセージ1');
        const error2 = AppError.validation('メッセージ2');
        expect(error1, isNot(equals(error2)));
      });

      test('異なる型は非等価', () {
        const error1 = AppError.validation('メッセージ');
        const error2 = AppError.notFound('メッセージ');
        expect(error1, isNot(equals(error2)));
      });
    });

    group('copyWith', () {
      test('validation の message を copyWith で変更できる', () {
        const original = AppError.validation('元のメッセージ');
        final copied = (original as ValidationError).copyWith(message: '新しいメッセージ');
        expect(copied.message, '新しいメッセージ');
      });

      test('unknown の message を copyWith で変更できる', () {
        const original = AppError.unknown('元のメッセージ');
        final copied = (original as UnknownError).copyWith(message: '変更後');
        expect(copied.message, '変更後');
      });
    });
  });
}
