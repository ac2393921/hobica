import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A centered error view widget with an optional retry button.
///
/// Displays an error icon and message using shadcn_flutter Alert component.
/// Can optionally show a retry button that triggers a callback when tapped.
class ErrorView extends StatelessWidget {
  /// Creates an error view.
  ///
  /// The [message] parameter is required and displays the error text.
  /// The [onRetry] parameter is optional and enables the retry button.
  /// The [retryButtonText] parameter customizes the retry button label.
  const ErrorView({
    required this.message,
    this.onRetry,
    this.retryButtonText,
    super.key,
  });

  /// Padding around the entire error view.
  static const double _containerPadding = 16.0;

  /// Spacing between error alert and retry button.
  static const double _alertButtonSpacing = 24.0;

  /// Error message to display.
  final String message;

  /// Optional callback to execute when retry button is tapped.
  final VoidCallback? onRetry;

  /// Optional text for the retry button. Defaults to '再試行'.
  final String? retryButtonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_containerPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Alert.destructive(
              leading: const Icon(BootstrapIcons.exclamationCircle, size: 20),
              title: const Text('エラー'),
              content: Text(message),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: _alertButtonSpacing),
              Button.primary(
                onPressed: onRetry,
                child: Text(retryButtonText ?? '再試行'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
