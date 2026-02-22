import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/widgets/empty_view.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  final testTheme = ThemeData(
    colorScheme: ColorSchemes.slate(ThemeMode.light),
    radius: 0.5,
  );

  group('EmptyView', () {
    testWidgets('should display empty message', (tester) async {
      const testMessage = 'No data available';

      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: EmptyView(message: testMessage),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should display default icon when icon is not provided',
        (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: EmptyView(message: 'Empty'),
          ),
        ),
      );

      expect(find.byIcon(BootstrapIcons.inbox), findsOneWidget);
    });

    testWidgets('should display custom icon when provided', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: EmptyView(
              message: 'Empty',
              icon: BootstrapIcons.folder,
            ),
          ),
        ),
      );

      expect(find.byIcon(BootstrapIcons.folder), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.inbox), findsNothing);
    });

    testWidgets('should display action button when onAction is provided',
        (tester) async {
      var actionCallCount = 0;

      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: Scaffold(
            child: EmptyView(
              message: 'Empty',
              onAction: () => actionCallCount++,
            ),
          ),
        ),
      );

      expect(find.byType(Button), findsOneWidget);

      await tester.tap(find.byType(Button));
      await tester.pump();

      expect(actionCallCount, equals(1));
    });

    testWidgets('should use custom action text when provided', (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: Scaffold(
            child: EmptyView(
              message: 'Empty',
              onAction: () {},
              actionText: 'Add Item',
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
    });

    testWidgets('should use default action text when not provided',
        (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: Scaffold(
            child: EmptyView(
              message: 'Empty',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.text('追加'), findsOneWidget);
    });

    testWidgets('should not display action button when onAction is null',
        (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          theme: testTheme,
          home: const Scaffold(
            child: EmptyView(message: 'Empty'),
          ),
        ),
      );

      expect(find.byType(Button), findsNothing);
    });
  });
}
