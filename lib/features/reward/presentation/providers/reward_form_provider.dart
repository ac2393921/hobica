import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/core/utils/validators.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/mocks/reward_repository_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reward_form_provider.freezed.dart';
part 'reward_form_provider.g.dart';

@freezed
class RewardFormState with _$RewardFormState {
  const factory RewardFormState({
    @Default('') String title,
    String? imageUri,
    @Default('') String targetPointsText,
    RewardCategory? category,
    String? memo,
    @Default(false) bool isSubmitting,
    AppError? submitError,
  }) = _RewardFormState;
}

@riverpod
class RewardForm extends _$RewardForm {
  // build() の引数を save() で参照するため保持する
  Reward? _initial;

  @override
  RewardFormState build({Reward? initial}) {
    _initial = initial;
    if (initial == null) {
      return const RewardFormState();
    }
    return RewardFormState(
      title: initial.title,
      imageUri: initial.imageUri,
      targetPointsText: initial.targetPoints.toString(),
      category: initial.category,
      memo: initial.memo,
    );
  }

  void updateTitle(String value) {
    state = state.copyWith(title: value, submitError: null);
  }

  void updateImageUri(String? value) {
    state = state.copyWith(imageUri: value, submitError: null);
  }

  void updateTargetPoints(String value) {
    state = state.copyWith(targetPointsText: value, submitError: null);
  }

  void updateCategory(RewardCategory? value) {
    state = state.copyWith(category: value, submitError: null);
  }

  void updateMemo(String? value) {
    state = state.copyWith(memo: value, submitError: null);
  }

  Future<Result<Reward, AppError>> save() async {
    final titleError = Validators.validateTitle(state.title);
    if (titleError != null) {
      final error = AppError.validation(titleError);
      state = state.copyWith(submitError: error);
      return Result.failure(error);
    }

    final pointsError = Validators.validatePoints(state.targetPointsText);
    if (pointsError != null) {
      final error = AppError.validation(pointsError);
      state = state.copyWith(submitError: error);
      return Result.failure(error);
    }

    state = state.copyWith(isSubmitting: true, submitError: null);

    final repository = ref.read(rewardRepositoryProvider);
    final targetPoints = int.parse(state.targetPointsText);

    final Result<Reward, AppError> result;
    final current = _initial;
    if (current == null) {
      result = await repository.createReward(
        title: state.title,
        imageUri: state.imageUri,
        targetPoints: targetPoints,
        category: state.category,
        memo: state.memo,
      );
    } else {
      result = await repository.updateReward(
        id: current.id,
        title: state.title,
        imageUri: state.imageUri,
        targetPoints: targetPoints,
        category: state.category,
        memo: state.memo,
        isActive: current.isActive,
      );
    }

    state = result.when(
      success: (_) {
        ref.invalidate(rewardListProvider);
        return state.copyWith(isSubmitting: false);
      },
      failure: (error) => state.copyWith(isSubmitting: false, submitError: error),
    );

    return result;
  }
}
