import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A centered loading indicator widget with an optional message.
///
/// Displays a [LinearProgressIndicator] from shadcn_flutter centered on the screen.
/// Can optionally show a loading message below the indicator.
class LoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator.
  ///
  /// The [message] parameter is optional and displays text below the spinner.
  const LoadingIndicator({
    this.message,
    super.key,
  });

  /// Maximum width ratio of the progress indicator relative to screen width.
  /// Set to 60% to prevent the indicator from becoming too wide on large screens.
  static const double _progressMaxWidthRatio = 0.6;

  /// Spacing between progress indicator and message text.
  static const double _messageSpacing = 16.0;

  /// Optional message to display below the loading indicator.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final progressIndicator = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * _progressMaxWidthRatio,
      ),
      child: const LinearProgressIndicator(),
    );

    return Center(
      child: message != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                progressIndicator,
                const SizedBox(height: _messageSpacing),
                Text(message!),
              ],
            )
          : progressIndicator,
    );
  }
}
