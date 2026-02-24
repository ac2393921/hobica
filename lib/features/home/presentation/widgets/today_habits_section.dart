import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 今日の習慣セクション。
class TodayHabitsSection extends StatelessWidget {
  const TodayHabitsSection({
    required this.habits,
    required this.completedIds,
    required this.onComplete,
    required this.onAddHabit,
    super.key,
  });

  static const double _headerSpacing = 8;
  static const double _itemSpacing = 8;

  final List<Habit> habits;
  final Set<int> completedIds;
  final void Function(int habitId) onComplete;
  final VoidCallback onAddHabit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('今日の習慣'),
            IconButton.ghost(
              icon: const Icon(BootstrapIcons.plusLg),
              onPressed: onAddHabit,
            ),
          ],
        ),
        const SizedBox(height: _headerSpacing),
        if (habits.isEmpty)
          EmptyView(
            message: '習慣がありません',
            onAction: onAddHabit,
          )
        else
          ...habits.map(
            (habit) => Padding(
              padding: const EdgeInsets.only(bottom: _itemSpacing),
              child: HabitCard(
                habit: habit,
                isCompleted: completedIds.contains(habit.id),
                onComplete: completedIds.contains(habit.id)
                    ? null
                    : () => onComplete(habit.id),
              ),
            ),
          ),
      ],
    );
  }
}
