import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// ご褒美セクション（上位3件表示）。
class TopRewardsSection extends StatelessWidget {
  const TopRewardsSection({
    required this.rewards,
    required this.currentPoints,
    required this.onViewAll,
    required this.onTapReward,
    super.key,
  });

  static const double _headerSpacing = 8;
  static const double _itemSpacing = 8;

  final List<Reward> rewards;
  final int currentPoints;
  final VoidCallback onViewAll;
  final void Function(int rewardId) onTapReward;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('ご褒美'),
            Button.ghost(
              onPressed: onViewAll,
              child: const Text('全て見る'),
            ),
          ],
        ),
        const SizedBox(height: _headerSpacing),
        if (rewards.isEmpty)
          EmptyView(
            message: 'ご褒美がありません',
            icon: BootstrapIcons.gift,
            onAction: onViewAll,
            actionText: '追加',
          )
        else
          ...rewards.map(
            (reward) => Padding(
              padding: const EdgeInsets.only(bottom: _itemSpacing),
              child: RewardCard(
                reward: reward,
                currentPoints: currentPoints,
                onTap: () => onTapReward(reward.id),
              ),
            ),
          ),
      ],
    );
  }
}
