import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/monetization/presentation/widgets/premium_pricing_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> _pumpPremiumPricingCard(WidgetTester tester) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: const Scaffold(
        child: SingleChildScrollView(
          child: PremiumPricingCard(),
        ),
      ),
    ),
  );
}

void main() {
  group('PremiumPricingCard', () {
    testWidgets('displays section title', (tester) async {
      await _pumpPremiumPricingCard(tester);

      expect(
        find.text(PremiumPricingCard.sectionTitle),
        findsOneWidget,
      );
    });

    testWidgets('displays price text', (tester) async {
      await _pumpPremiumPricingCard(tester);

      expect(
        find.text(PremiumPricingCard.priceText),
        findsOneWidget,
      );
    });

    testWidgets('displays trial text', (tester) async {
      await _pumpPremiumPricingCard(tester);

      expect(
        find.text(PremiumPricingCard.trialText),
        findsOneWidget,
      );
    });

    testWidgets('is wrapped in a Card', (tester) async {
      await _pumpPremiumPricingCard(tester);

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
