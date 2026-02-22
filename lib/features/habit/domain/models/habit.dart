import 'package:freezed_annotation/freezed_annotation.dart';

import 'frequency_type.dart';

part 'habit.freezed.dart';
part 'habit.g.dart';

@freezed
class Habit with _$Habit {
  const factory Habit({
    required int id,
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    DateTime? remindTime,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _Habit;

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
}
