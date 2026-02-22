import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_redemption.freezed.dart';
part 'reward_redemption.g.dart';

@freezed
class RewardRedemption with _$RewardRedemption {
  const factory RewardRedemption({
    required int id,
    required int rewardId,
    required int pointsSpent,
    required DateTime redeemedAt,
  }) = _RewardRedemption;

  factory RewardRedemption.fromJson(Map<String, dynamic> json) =>
      _$RewardRedemptionFromJson(json);
}
