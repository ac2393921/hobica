import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/widgets/habit_streak_indicator.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    required this.habit,
    required this.isCompleted,
    this.streakDays = 0,
    this.onComplete,
    super.key,
  });

  static const double _cardPadding = 16;
  static const double _titleMetaSpacing = 4;
  static const double _metaStatusSpacing = 4;
  static const double _metaItemSpacing = 8;
  static const double _contentButtonSpacing = 8;

  final Habit habit;
  final bool isCompleted;
  final int streakDays;
  final VoidCallback? onComplete;

  String get _frequencyText => switch (habit.frequencyType) {
        FrequencyType.daily => '毎日',
        FrequencyType.weekly => '週${habit.frequencyValue}回',
      };

  Widget _buildCompletionWidget() {
    if (isCompleted) {
      return const Icon(BootstrapIcons.checkCircleFill);
    }
    if (onComplete != null) {
      return Button.ghost(
        onPressed: onComplete,
        child: const Icon(BootstrapIcons.circle),
      );
    }
    return const Icon(BootstrapIcons.circle);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(_cardPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.title),
                  const SizedBox(height: _titleMetaSpacing),
                  Wrap(
                    spacing: _metaItemSpacing,
                    children: [
                      Text(_frequencyText),
                      PrimaryBadge(
                        child: Text('${habit.points}pt'),
                      ),
                      if (streakDays > 0)
                        HabitStreakIndicator(streakDays: streakDays),
                    ],
                  ),
                  const SizedBox(height: _metaStatusSpacing),
                  Text(isCompleted ? '今日達成済み' : '未達成'),
                ],
              ),
            ),
            const SizedBox(width: _contentButtonSpacing),
            _buildCompletionWidget(),
          ],
        ),
      ),
    );
  }
}
