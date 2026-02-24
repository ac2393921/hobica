import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
// クロスフィーチャー依存: habit完了後にwallet残高を更新する（アプリ設計上の意図的な依存）
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_completion_provider.g.dart';

/// 今日完了した習慣IDセットを管理するプロバイダー。
///
/// [HabitList] は AsyncNotifier<List<Habit>> のため完了IDセットを持てない。
/// 関心を分離するために独立した Notifier として定義する。
@riverpod
class HabitCompletion extends _$HabitCompletion {
  @override
  Set<int> build() => const {};

  Future<Result<HabitLog, AppError>> completeHabit(int habitId) async {
    final result =
        await ref.read(habitRepositoryProvider).completeHabit(habitId);
    if (result is Success<HabitLog, AppError>) {
      state = {...state, habitId};
      await ref
          .read(walletRepositoryProvider)
          .addPoints(result.value.points);
      ref.invalidate(walletBalanceProvider);
    }
    return result;
  }
}
