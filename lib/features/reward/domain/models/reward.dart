import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward.freezed.dart';

enum RewardCategory { item, experience, food, beauty, entertainment, other }

@freezed
class Reward with _$Reward {
  const factory Reward({
    required int id,
    required String title,
    required int targetPoints,
    required DateTime createdAt,
    required bool isActive,
    String? imageUri,
    RewardCategory? category,
    String? memo,
  }) = _Reward;
}
