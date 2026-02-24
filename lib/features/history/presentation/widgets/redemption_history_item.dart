import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RedemptionHistoryItem extends StatelessWidget {
  const RedemptionHistoryItem({required this.redemption, super.key});

  static const double _cardPadding = 16;
  static const double _dateRewardSpacing = 4;

  final RewardRedemption redemption;

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
                  Text(DateFormat('yyyy/MM/dd').format(redemption.redeemedAt)),
                  const SizedBox(height: _dateRewardSpacing),
                  Text('ご褒美ID: ${redemption.rewardId}'),
                ],
              ),
            ),
            SecondaryBadge(child: Text('${redemption.pointsSpent}pt')),
          ],
        ),
      ),
    );
  }
}
