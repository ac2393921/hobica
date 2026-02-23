import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_progress_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({
    required this.reward,
    required this.currentPoints,
    this.onTap,
    super.key,
  });

  static const double _cardPadding = 16;
  static const double _titleCategorySpacing = 4;
  static const double _categoryProgressSpacing = 8;

  final Reward reward;
  final int currentPoints;
  final VoidCallback? onTap;

  String _categoryLabel(RewardCategory category) => switch (category) {
        RewardCategory.item => '物品',
        RewardCategory.experience => '体験',
        RewardCategory.food => '食',
        RewardCategory.beauty => '美容',
        RewardCategory.entertainment => '娯楽',
        RewardCategory.other => 'その他',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(_cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reward.title),
              if (reward.category != null) ...[
                const SizedBox(height: _titleCategorySpacing),
                SecondaryBadge(
                  child: Text(_categoryLabel(reward.category!)),
                ),
              ],
              const SizedBox(height: _categoryProgressSpacing),
              RewardProgressBar(
                currentPoints: currentPoints,
                targetPoints: reward.targetPoints,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
