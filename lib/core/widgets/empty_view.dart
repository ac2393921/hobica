import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A centered empty state view widget with an optional action button.
///
/// Displays an icon and message when there is no data to show.
/// Can optionally show an action button that triggers a callback when tapped.
class EmptyView extends StatelessWidget {
  /// Creates an empty view.
  ///
  /// The [message] parameter is required and displays the empty state text.
  /// The [icon] parameter is optional and defaults to [BootstrapIcons.inbox].
  /// The [onAction] parameter is optional and enables the action button.
  /// The [actionText] parameter customizes the action button label.
  const EmptyView({
    required this.message,
    this.icon,
    this.onAction,
    this.actionText,
    super.key,
  });

  /// Size of the empty state icon.
  static const double _iconSize = 64.0;

  /// Alpha value for icon color (153 ≈ 60% opacity).
  /// Makes the icon visually subtle while remaining recognizable.
  static const int _iconAlpha = 153;

  /// Padding around the entire empty view.
  static const double _containerPadding = 16.0;

  /// Spacing between icon and message text.
  static const double _iconMessageSpacing = 16.0;

  /// Spacing between message text and action button.
  static const double _messageActionSpacing = 24.0;

  /// Empty state message to display.
  final String message;

  /// Optional icon to display. Defaults to [BootstrapIcons.inbox].
  final IconData? icon;

  /// Optional callback to execute when action button is tapped.
  final VoidCallback? onAction;

  /// Optional text for the action button. Defaults to '追加'.
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_containerPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? BootstrapIcons.inbox,
              size: _iconSize,
              color: theme.colorScheme.foreground.withAlpha(_iconAlpha),
            ),
            const SizedBox(height: _iconMessageSpacing),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: _messageActionSpacing),
              Button.primary(
                onPressed: onAction,
                child: Text(actionText ?? '追加'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
