import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets/loading_indicator.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  final testTheme = ThemeData(
    colorScheme: ColorSchemes.slate(ThemeMode.light),
    radius: 0.5,
  );

  group('LoadingIndicator', () {
    testWidgets('should render LinearProgressIndicator from shadcn_flutter', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: LoadingIndicator(),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should display message when provided', (tester) async {
      const testMessage = 'Loading data...';

      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: LoadingIndicator(message: testMessage),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should not display message when not provided', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: LoadingIndicator(),
          ),
        ),
      );

      // Only LinearProgressIndicator should be present, no Text widget
      expect(find.byType(Text), findsNothing);
    });
  });
}
