import 'package:hobica/core/utils/date_utils.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RedemptionHistoryList extends StatelessWidget {
  const RedemptionHistoryList({
    required this.redemptions,
    super.key,
  });

  final List<RewardRedemption> redemptions;

  @override
  Widget build(BuildContext context) {
    if (redemptions.isEmpty) {
      return const EmptyView(message: '交換履歴がありません');
    }

    final grouped = groupByDate(redemptions, (r) => r.redeemedAt);
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final items = grouped[date]!;
        return _DateGroup(date: date, redemptions: items);
      },
    );
  }
}

class _DateGroup extends StatelessWidget {
  const _DateGroup({
    required this.date,
    required this.redemptions,
  });

  final DateTime date;
  final List<RewardRedemption> redemptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            date.toJaDateLabel(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        for (final redemption in redemptions)
          _RedemptionItem(redemption: redemption),
      ],
    );
  }
}

class _RedemptionItem extends StatelessWidget {
  const _RedemptionItem({required this.redemption});

  final RewardRedemption redemption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ご褒美 #${redemption.rewardId}'),
          Text(
            '-${redemption.pointsSpent}pt',
            style: TextStyle(
              color: Theme.of(context).colorScheme.destructive,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
