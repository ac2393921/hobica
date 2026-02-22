import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets/error_view.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  final testTheme = ThemeData(
    colorScheme: ColorSchemes.slate(ThemeMode.light),
    radius: 0.5,
  );

  group('ErrorView', () {
    testWidgets('should display error message', (tester) async {
      const testMessage = 'An error occurred';

      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: ErrorView(message: testMessage),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should display Alert component with error icon', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: ErrorView(message: 'Error'),
          ),
        ),
      );

      expect(find.byType(Alert), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.exclamationCircle), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided',
        (tester) async {
      var retryCallCount = 0;

      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: Scaffold(
            child: ErrorView(
              message: 'Error',
              onRetry: () => retryCallCount++,
            ),
          ),
        ),
      );

      expect(find.text('再試行'), findsOneWidget);
      expect(find.byType(Button), findsOneWidget);

      await tester.tap(find.byType(Button));
      await tester.pump();

      expect(retryCallCount, equals(1));
    });

    testWidgets('should use custom retry button text when provided',
        (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: Scaffold(
            child: ErrorView(
              message: 'Error',
              onRetry: () {},
              retryButtonText: 'Try Again',
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('再試行'), findsNothing);
    });

    testWidgets('should not display retry button when onRetry is null',
        (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: ErrorView(message: 'Error'),
          ),
        ),
      );

      expect(find.byType(Button), findsNothing);
      expect(find.text('再試行'), findsNothing);
    });
  });
}
