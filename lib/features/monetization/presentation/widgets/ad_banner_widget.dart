import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Mock ad banner widget.
///
/// Displays a placeholder banner for ad placement.
/// Does not use the google_mobile_ads SDK; intended to be replaced
/// when real ad integration is implemented.
class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({
    required this.height,
    super.key,
  });

  static const double defaultHeight = 60.0;
  static const double _iconSize = 20.0;
  static const double _iconTextSpacing = 8.0;

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '広告',
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.muted,
            borderRadius: BorderRadius.circular(theme.radiusXl),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  BootstrapIcons.megaphone,
                  size: _iconSize,
                  color: theme.colorScheme.mutedForeground,
                ),
                const SizedBox(width: _iconTextSpacing),
                Text(
                  '広告',
                  style: TextStyle(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
