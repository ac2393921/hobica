import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Immutable data class representing a single premium feature.
class PremiumFeatureItem {
  const PremiumFeatureItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

/// Displays a list of premium features.
///
/// Renders each [PremiumFeatureItem] as a Card with icon, title, and
/// description. Data is received via props; no data fetching is performed.
class PremiumFeaturesList extends StatelessWidget {
  const PremiumFeaturesList({
    required this.features,
    super.key,
  });

  static const double _cardSpacing = 8.0;
  static const double _cardPadding = 12.0;
  static const double _iconSize = 24.0;
  static const double _iconTextSpacing = 12.0;
  static const double _titleDescriptionSpacing = 4.0;

  final List<PremiumFeatureItem> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('プレミアム機能'),
        if (features.isEmpty)
          const Text('プレミアム機能はありません')
        else
          ..._buildFeatureCards(context),
      ],
    );
  }

  List<Widget> _buildFeatureCards(BuildContext context) {
    final theme = Theme.of(context);
    final items = <Widget>[];

    for (var i = 0; i < features.length; i++) {
      final feature = features[i];
      items.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: Row(
              children: [
                Icon(
                  feature.icon,
                  size: _iconSize,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: _iconTextSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: _titleDescriptionSpacing),
                      Text(
                        feature.description,
                        style: TextStyle(
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      if (i < features.length - 1) {
        items.add(const SizedBox(height: _cardSpacing));
      }
    }

    return items;
  }
}
