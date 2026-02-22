import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
class AppError with _$AppError {
  const factory AppError.validation(String message) = ValidationError;
  const factory AppError.notFound(String message) = NotFoundError;
  const factory AppError.alreadyCompleted(String message) = AlreadyCompletedError;
  const factory AppError.insufficientPoints(String message) = InsufficientPointsError;
  const factory AppError.unknown(String message) = UnknownError;
}
