import 'package:hobica/features/monetization/presentation/widgets/premium_features_list.dart';
import 'package:hobica/features/monetization/presentation/widgets/premium_pricing_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  static const String appBarTitle = 'プレミアム';
  static const String headerText = 'hobica プレミアム';
  static const String subscribeButtonText = 'プレミアムに登録する';
  static const String footnoteText = '※ 自動更新されます。いつでも解約可能です。';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      headers: const [AppBar(title: Text(appBarTitle))],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(BootstrapIcons.starFill, size: 20),
                SizedBox(width: 8),
                Text(
                  headerText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const PremiumFeaturesList(),
            const SizedBox(height: 24),
            const PremiumPricingCard(),
            const SizedBox(height: 24),
            const SizedBox(
              width: double.infinity,
              child: Button.primary(
                child: Text(subscribeButtonText),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              footnoteText,
              textAlign: TextAlign.center,
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
