import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_form_provider.freezed.dart';
part 'habit_form_provider.g.dart';

@freezed
class HabitFormState with _$HabitFormState {
  const factory HabitFormState({
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    DateTime? remindTime,
    @Default(false) bool isSubmitting,
    AppError? error,
  }) = _HabitFormState;

  factory HabitFormState.initial() => const HabitFormState(
        title: '',
        points: 30,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
      );

  factory HabitFormState.fromHabit(Habit habit) => HabitFormState(
        title: habit.title,
        points: habit.points,
        frequencyType: habit.frequencyType,
        frequencyValue: habit.frequencyValue,
        remindTime: habit.remindTime,
      );
}

@riverpod
class HabitForm extends _$HabitForm {
  Habit? _initialHabit;

  @override
  HabitFormState build({Habit? initialHabit}) {
    _initialHabit = initialHabit;
    return initialHabit != null
        ? HabitFormState.fromHabit(initialHabit)
        : HabitFormState.initial();
  }

  void updateTitle(String title) =>
      state = state.copyWith(title: title, error: null);

  void updatePoints(int points) =>
      state = state.copyWith(points: points, error: null);

  void updateFrequencyType(FrequencyType type) =>
      state = state.copyWith(frequencyType: type, error: null);

  void updateFrequencyValue(int value) =>
      state = state.copyWith(frequencyValue: value, error: null);

  void updateRemindTime(DateTime? time) =>
      state = state.copyWith(remindTime: time, error: null);

  Future<Result<Habit, AppError>> submit() async {
    state = state.copyWith(isSubmitting: true, error: null);
    final repo = ref.read(habitRepositoryProvider);
    final Result<Habit, AppError> result;

    if (_initialHabit == null) {
      result = await repo.createHabit(
        title: state.title,
        points: state.points,
        frequencyType: state.frequencyType,
        frequencyValue: state.frequencyValue,
        remindTime: state.remindTime,
      );
    } else {
      result = await repo.updateHabit(
        _initialHabit!.copyWith(
          title: state.title,
          points: state.points,
          frequencyType: state.frequencyType,
          frequencyValue: state.frequencyValue,
          remindTime: state.remindTime,
        ),
      );
    }

    state = state.copyWith(
      isSubmitting: false,
      error: result is Failure<Habit, AppError> ? result.error : null,
    );
    if (result is Success) ref.invalidate(habitListProvider);
    return result;
  }

  Future<Result<void, AppError>> delete() async {
    if (_initialHabit == null) return const Result<void, AppError>.success(null);
    final result =
        await ref.read(habitRepositoryProvider).deleteHabit(_initialHabit!.id);
    if (result is Success) ref.invalidate(habitListProvider);
    return result;
  }
}
