import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 今日の習慣セクション。
///
/// [habits] に含まれる習慣を [HabitCard] で一覧表示する。
/// データ取得は行わず、全データを props で受け取る Presentational Widget。
class TodayHabitsSection extends StatelessWidget {
  const TodayHabitsSection({
    required this.habits,
    required this.completedIds,
    required this.onComplete,
    this.onAddHabit,
    super.key,
  });

  static const double _cardSpacing = 8;

  final List<Habit> habits;
  final Set<int> completedIds;

  final void Function(int habitId) onComplete;
  final VoidCallback? onAddHabit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (habits.isEmpty)
          const Text('今日の習慣がありません')
        else
          ..._buildHabitCards(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('今日の習慣'),
        if (onAddHabit != null)
          IconButton.ghost(
            icon: const Icon(Icons.add),
            onPressed: onAddHabit,
          ),
      ],
    );
  }

  List<Widget> _buildHabitCards() {
    final items = <Widget>[];
    for (var i = 0; i < habits.length; i++) {
      final habit = habits[i];
      final isCompleted = completedIds.contains(habit.id);
      items.add(
        HabitCard(
          habit: habit,
          isCompleted: isCompleted,
          onComplete: isCompleted ? null : () => onComplete(habit.id),
        ),
      );
      if (i < habits.length - 1) {
        items.add(const SizedBox(height: _cardSpacing));
      }
    }
    return items;
  }
}
