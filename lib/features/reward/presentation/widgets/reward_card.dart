import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/utils/reward_category_labels.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_image_view.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_progress_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({
    required this.reward,
    required this.currentPoints,
    this.onTap,
    super.key,
  });

  static const double _imageHeight = 80.0;
  static const double _cardPadding = 12.0;
  static const double _titleSpacing = 4.0;

  final Reward reward;
  final int currentPoints;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RewardImageView(
              imageUri: reward.imageUri,
              height: _imageHeight,
              iconSize: 32,
            ),
            Padding(
              padding: const EdgeInsets.all(_cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reward.title),
                  const SizedBox(height: _titleSpacing),
                  if (reward.category != null)
                    PrimaryBadge(
                      child: Text(rewardCategoryLabels[reward.category!]!),
                    ),
                  const SizedBox(height: _titleSpacing),
                  RewardProgressBar(
                    currentPoints: currentPoints,
                    targetPoints: reward.targetPoints,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
