import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_redemption.freezed.dart';

@freezed
class RewardRedemption with _$RewardRedemption {
  const factory RewardRedemption({
    required int id,
    required int rewardId,
    required int pointsSpent,
    required DateTime redeemedAt,
  }) = _RewardRedemption;
}
