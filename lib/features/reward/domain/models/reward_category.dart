import 'package:json_annotation/json_annotation.dart';

enum RewardCategory {
  @JsonValue('item')
  item,

  @JsonValue('experience')
  experience,

  @JsonValue('food')
  food,

  @JsonValue('beauty')
  beauty,

  @JsonValue('entertainment')
  entertainment,

  @JsonValue('other')
  other,
}
