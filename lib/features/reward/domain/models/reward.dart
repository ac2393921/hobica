import 'package:freezed_annotation/freezed_annotation.dart';

import 'reward_category.dart';

part 'reward.freezed.dart';
part 'reward.g.dart';

@freezed
class Reward with _$Reward {
  const factory Reward({
    required int id,
    required String title,
    String? imageUri,
    required int targetPoints,
    RewardCategory? category,
    String? memo,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _Reward;

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);
}
