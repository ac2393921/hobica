import 'package:shadcn_flutter/shadcn_flutter.dart';

class PremiumPricingCard extends StatelessWidget {
  const PremiumPricingCard({super.key});

  static const String sectionTitle = '料金プラン';
  static const String priceText = '月額 ¥480';
  static const String trialText = 'まずは無料で試す';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(sectionTitle),
            const SizedBox(height: 12),
            const Text(
              priceText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              trialText,
              style: TextStyle(
                color: colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
