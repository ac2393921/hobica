import 'package:json_annotation/json_annotation.dart';

enum FrequencyType {
  @JsonValue('daily')
  daily,

  @JsonValue('weekly')
  weekly,
}
