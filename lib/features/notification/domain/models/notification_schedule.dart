import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_schedule.freezed.dart';
part 'notification_schedule.g.dart';

@freezed
class NotificationSchedule with _$NotificationSchedule {
  const factory NotificationSchedule({
    required int id,
    required int habitId,
    required String habitTitle,
    required DateTime scheduledTime,
  }) = _NotificationSchedule;

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleFromJson(json);
}
