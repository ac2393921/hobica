import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_log.freezed.dart';
part 'habit_log.g.dart';

@freezed
class HabitLog with _$HabitLog {
  const factory HabitLog({
    required int id,
    required int habitId,
    required DateTime date,
    required int points,
    required DateTime createdAt,
  }) = _HabitLog;

  factory HabitLog.fromJson(Map<String, dynamic> json) =>
      _$HabitLogFromJson(json);
}
