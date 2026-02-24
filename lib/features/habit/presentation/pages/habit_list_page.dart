import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/router/routes.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/providers/habit_completion_provider.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 習慣一覧画面。
///
/// 全アクティブ習慣を表示し、完了操作・詳細遷移・編集・削除を提供する。
class HabitListPage extends ConsumerWidget {
  const HabitListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListProvider);
    final completedIds = ref.watch(habitCompletionProvider);

    return Scaffold(
      headers: [
        AppBar(
          title: const Text('習慣'),
          trailing: [
            IconButton.ghost(
              icon: const Icon(Icons.add),
              onPressed: () => context.goNamed(AppRouteNames.habitForm),
            ),
          ],
        ),
      ],
      child: habitsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(habitListProvider),
        ),
        data: (habits) => habits.isEmpty
            ? EmptyView(
                message: '習慣がありません',
                onAction: () => context.goNamed(AppRouteNames.habitForm),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: habits.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return _HabitListItem(
                    habit: habit,
                    isCompleted: completedIds.contains(habit.id),
                    onTap: () => context.goNamed(
                      AppRouteNames.habitDetail,
                      pathParameters: {
                        AppRouteParams.id: habit.id.toString(),
                      },
                    ),
                    onComplete: () => ref
                        .read(habitCompletionProvider.notifier)
                        .completeHabit(habit.id),
                    onEdit: () => context.goNamed(
                      AppRouteNames.habitEdit,
                      pathParameters: {
                        AppRouteParams.id: habit.id.toString(),
                      },
                      extra: habit,
                    ),
                    onDelete: () => ref
                        .read(habitListProvider.notifier)
                        .deleteHabit(habit.id),
                  );
                },
              ),
      ),
    );
  }
}

class _HabitListItem extends StatelessWidget {
  const _HabitListItem({
    required this.habit,
    required this.isCompleted,
    required this.onTap,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  final Habit habit;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showActionSheet(context),
      child: HabitCard(
        habit: habit,
        isCompleted: isCompleted,
        onComplete: isCompleted ? null : onComplete,
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('操作を選択'),
        actions: [
          Button.outline(
            onPressed: () {
              Navigator.of(context).pop();
              onEdit();
            },
            child: const Text('編集'),
          ),
          Button.destructive(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
