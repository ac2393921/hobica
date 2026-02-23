import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/router/routes.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/providers/habit_detail_provider.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_completion_calendar.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_streak_indicator.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 習慣詳細画面。
///
/// Habit 情報・Streak・カレンダー・リマインドを表示する。
class HabitDetailPage extends ConsumerWidget {
  const HabitDetailPage({required this.habitId, super.key});

  final int habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(habitDetailProvider(habitId));

    return detailAsync.when(
      loading: () => const Scaffold(
        headers: [AppBar(title: Text('習慣詳細'))],
        child: LoadingIndicator(),
      ),
      error: (error, _) => Scaffold(
        headers: const [AppBar(title: Text('習慣詳細'))],
        child: ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(habitDetailProvider(habitId)),
        ),
      ),
      data: (detail) {
        if (detail == null) {
          return const Scaffold(
            headers: [AppBar(title: Text('習慣詳細'))],
            child: ErrorView(message: '習慣が見つかりません'),
          );
        }

        return Scaffold(
          headers: [
            AppBar(
              title: Text(detail.habit.title),
              trailing: [
                IconButton.ghost(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.goNamed(
                    AppRouteNames.habitEdit,
                    pathParameters: {
                      AppRouteParams.id: habitId.toString(),
                    },
                    extra: detail.habit,
                  ),
                ),
                IconButton.ghost(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _onDelete(context, ref, detail.habit),
                ),
              ],
            ),
          ],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HabitInfoSection(
                  habit: detail.habit,
                  streakDays: detail.streakDays,
                ),
                const SizedBox(height: 16),
                _CalendarSection(completedDates: detail.completedDates),
                if (detail.habit.remindTime != null) ...[
                  const SizedBox(height: 16),
                  _RemindSection(remindTime: detail.habit.remindTime!),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('習慣を削除'),
        content: Text('「${habit.title}」を削除しますか？'),
        actions: [
          Button.outline(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          Button.destructive(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final result =
        await ref.read(habitListProvider.notifier).deleteHabit(habitId);
    if (!context.mounted) return;
    if (result is Success) {
      context.pop();
    }
  }
}

class _HabitInfoSection extends StatelessWidget {
  const _HabitInfoSection({required this.habit, required this.streakDays});

  final Habit habit;
  final int streakDays;

  String get _frequencyText => switch (habit.frequencyType) {
        FrequencyType.daily => '毎日',
        FrequencyType.weekly => '週${habit.frequencyValue}回',
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.title),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(_frequencyText),
                PrimaryBadge(child: Text('${habit.points}pt')),
                if (streakDays > 0)
                  HabitStreakIndicator(streakDays: streakDays),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({required this.completedDates});

  final Set<DateTime> completedDates;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('達成カレンダー'),
            const SizedBox(height: 8),
            HabitCompletionCalendar(completedDates: completedDates),
          ],
        ),
      ),
    );
  }
}

class _RemindSection extends StatelessWidget {
  const _RemindSection({required this.remindTime});

  final DateTime remindTime;

  @override
  Widget build(BuildContext context) {
    final timeText =
        '${remindTime.hour.toString().padLeft(2, '0')}:${remindTime.minute.toString().padLeft(2, '0')}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(BootstrapIcons.alarm),
            const SizedBox(width: 8),
            Text('リマインド: $timeText'),
          ],
        ),
      ),
    );
  }
}
