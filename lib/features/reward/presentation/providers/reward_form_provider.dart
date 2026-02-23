import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/presentation/providers/reward_form_state.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reward_form_provider.g.dart';

@riverpod
class RewardForm extends _$RewardForm {
  @override
  RewardFormState build() => const RewardFormState();

  Future<void> submitCreate({
    required String title,
    required int targetPoints,
    String? imageUri,
    RewardCategory? category,
    String? memo,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null, savedReward: null);
    try {
      final repository = ref.read(rewardRepositoryProvider);
      final result = await repository.createReward(
        title: title,
        targetPoints: targetPoints,
        imageUri: imageUri,
        category: category,
        memo: memo,
      );
      result.when(
        success: (reward) {
          ref.invalidate(rewardListProvider);
          state = state.copyWith(isSubmitting: false, savedReward: reward);
        },
        failure: (error) {
          state = state.copyWith(
            isSubmitting: false,
            error: error.when(
              validation: (m) => m,
              notFound: (m) => m,
              alreadyCompleted: (m) => m,
              insufficientPoints: (m) => m,
              unknown: (m) => m,
            ),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }

  Future<void> submitUpdate(Reward reward) async {
    state = state.copyWith(isSubmitting: true, error: null, savedReward: null);
    try {
      final repository = ref.read(rewardRepositoryProvider);
      final result = await repository.updateReward(reward);
      result.when(
        success: (updated) {
          ref.invalidate(rewardListProvider);
          state = state.copyWith(isSubmitting: false, savedReward: updated);
        },
        failure: (error) {
          state = state.copyWith(
            isSubmitting: false,
            error: error.when(
              validation: (m) => m,
              notFound: (m) => m,
              alreadyCompleted: (m) => m,
              insufficientPoints: (m) => m,
              unknown: (m) => m,
            ),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }
}
