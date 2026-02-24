import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 上位ご褒美セクション。
///
/// [rewards] に含まれるご褒美を [RewardCard] で一覧表示する。
/// 上位 N 件への絞り込みは呼び元の責務。
/// データ取得は行わず、全データを props で受け取る Presentational Widget。
class TopRewardsSection extends StatelessWidget {
  const TopRewardsSection({
    required this.rewards,
    required this.currentPoints,
    this.onSeeAll,
    this.onRewardTap,
    super.key,
  });

  static const double _cardSpacing = 8;

  final List<Reward> rewards;
  final int currentPoints;

  final VoidCallback? onSeeAll;
  final void Function(int rewardId)? onRewardTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (rewards.isEmpty)
          const Text('ご褒美がありません')
        else
          ..._buildRewardCards(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('ご褒美'),
        if (onSeeAll != null)
          Button.ghost(
            onPressed: onSeeAll,
            child: const Text('全て見る'),
          ),
      ],
    );
  }

  List<Widget> _buildRewardCards() {
    final items = <Widget>[];
    for (var i = 0; i < rewards.length; i++) {
      final reward = rewards[i];
      items.add(
        RewardCard(
          reward: reward,
          currentPoints: currentPoints,
          onTap: onRewardTap != null ? () => onRewardTap!(reward.id) : null,
        ),
      );
      if (i < rewards.length - 1) {
        items.add(const SizedBox(height: _cardSpacing));
      }
    }
    return items;
  }
}
