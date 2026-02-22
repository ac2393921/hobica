import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';

enum FrequencyType { daily, weekly }

@freezed
class Habit with _$Habit {
  const factory Habit({
    required int id,
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    required DateTime createdAt,
    required bool isActive,
    DateTime? remindTime,
  }) = _Habit;
}
