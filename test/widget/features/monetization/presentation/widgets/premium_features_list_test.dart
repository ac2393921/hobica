import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/monetization/presentation/widgets/premium_features_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

const _customFeatures = [
  PremiumFeatureItem(
    title: '広告非表示',
    description: '全ての広告を非表示にします',
    icon: BootstrapIcons.eyeSlash,
  ),
  PremiumFeatureItem(
    title: '詳細統計',
    description: '習慣の詳細な統計データを表示します',
    icon: BootstrapIcons.graphUp,
  ),
];

Future<void> _pumpPremiumFeaturesList(
  WidgetTester tester, {
  List<PremiumFeatureItem>? features,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: SingleChildScrollView(
          child: PremiumFeaturesList(
            features: features ?? PremiumFeaturesList.defaultFeatures,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('PremiumFeaturesList', () {
    testWidgets('displays section title', (tester) async {
      await _pumpPremiumFeaturesList(tester);

      expect(find.text(PremiumFeaturesList.sectionTitle), findsOneWidget);
    });

    testWidgets('displays default feature titles and descriptions', (
      tester,
    ) async {
      await _pumpPremiumFeaturesList(tester);

      for (final feature in PremiumFeaturesList.defaultFeatures) {
        expect(find.text(feature.title), findsOneWidget);
        expect(find.text(feature.description), findsOneWidget);
      }
    });

    testWidgets('is wrapped in a Card', (tester) async {
      await _pumpPremiumFeaturesList(tester);

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders custom features', (tester) async {
      await _pumpPremiumFeaturesList(tester, features: _customFeatures);

      expect(find.text('広告非表示'), findsOneWidget);
      expect(find.text('全ての広告を非表示にします'), findsOneWidget);
      expect(find.text('詳細統計'), findsOneWidget);
      expect(find.text('習慣の詳細な統計データを表示します'), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.eyeSlash), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.graphUp), findsOneWidget);
    });

    testWidgets('shows empty message when features list is empty', (
      tester,
    ) async {
      await _pumpPremiumFeaturesList(tester, features: const []);

      expect(find.text(PremiumFeaturesList.emptyMessage), findsOneWidget);
    });
  });

  group('PremiumFeatureItem', () {
    test('stores title, description, and icon', () {
      const item = PremiumFeatureItem(
        title: 'テスト機能',
        description: 'テスト説明',
        icon: BootstrapIcons.star,
      );

      expect(item.title, 'テスト機能');
      expect(item.description, 'テスト説明');
      expect(item.icon, BootstrapIcons.star);
    });
  });
}
