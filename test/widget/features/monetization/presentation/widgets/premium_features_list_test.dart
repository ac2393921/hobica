import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/monetization/presentation/widgets/premium_features_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> _pumpPremiumFeaturesList(WidgetTester tester) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: const Scaffold(
        child: SingleChildScrollView(
          child: PremiumFeaturesList(),
        ),
      ),
    ),
  );
}

void main() {
  group('PremiumFeaturesList', () {
    testWidgets('displays section title', (tester) async {
      await _pumpPremiumFeaturesList(tester);

      expect(
        find.text(PremiumFeaturesList.sectionTitle),
        findsOneWidget,
      );
    });

    testWidgets('displays all 6 feature texts', (tester) async {
      await _pumpPremiumFeaturesList(tester);

      for (final feature in PremiumFeaturesList.features) {
        expect(find.text(feature), findsOneWidget);
      }
    });

    testWidgets('displays check icons for each feature', (tester) async {
      await _pumpPremiumFeaturesList(tester);

      expect(
        find.byIcon(BootstrapIcons.checkLg),
        findsNWidgets(PremiumFeaturesList.features.length),
      );
    });

    testWidgets('is wrapped in a Card', (tester) async {
      await _pumpPremiumFeaturesList(tester);

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
