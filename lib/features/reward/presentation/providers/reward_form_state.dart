import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';

part 'reward_form_state.freezed.dart';

@freezed
class RewardFormState with _$RewardFormState {
  const factory RewardFormState({
    @Default(false) bool isSubmitting,
    String? error,
    Reward? savedReward,
  }) = _RewardFormState;
}
