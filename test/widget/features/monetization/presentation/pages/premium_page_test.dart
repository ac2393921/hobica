import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/features/monetization/presentation/pages/premium_page.dart';
import 'package:hobica/features/monetization/presentation/widgets/premium_features_list.dart';
import 'package:hobica/features/monetization/presentation/widgets/premium_pricing_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> _pumpPremiumPage(WidgetTester tester) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const PremiumPage(),
      ),
    ],
  );

  await tester.pumpWidget(
    ShadcnApp.router(
      theme: _testTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  group('PremiumPage', () {
    testWidgets('displays AppBar with title', (tester) async {
      await _pumpPremiumPage(tester);

      expect(find.text(PremiumPage.appBarTitle), findsOneWidget);
    });

    testWidgets('displays header text with star icon', (tester) async {
      await _pumpPremiumPage(tester);

      expect(find.text(PremiumPage.headerText), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.starFill), findsOneWidget);
    });

    testWidgets('contains PremiumFeaturesList', (tester) async {
      await _pumpPremiumPage(tester);

      expect(find.byType(PremiumFeaturesList), findsOneWidget);
    });

    testWidgets('contains PremiumPricingCard', (tester) async {
      await _pumpPremiumPage(tester);

      expect(find.byType(PremiumPricingCard), findsOneWidget);
    });

    testWidgets('displays subscribe button', (tester) async {
      await _pumpPremiumPage(tester);

      expect(
        find.text(PremiumPage.subscribeButtonText),
        findsOneWidget,
      );
    });

    testWidgets('subscribe button is disabled', (tester) async {
      await _pumpPremiumPage(tester);

      final button = tester.widget<Button>(
        find.widgetWithText(Button, PremiumPage.subscribeButtonText),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('displays footnote text', (tester) async {
      await _pumpPremiumPage(tester);

      expect(find.text(PremiumPage.footnoteText), findsOneWidget);
    });
  });
}
