import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/monetization/presentation/widgets/premium_features_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

const _testFeatures = [
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
  PremiumFeatureItem(
    title: 'テーマカスタマイズ',
    description: 'アプリのテーマを自由に変更できます',
    icon: BootstrapIcons.palette,
  ),
];

Future<void> pumpPremiumFeaturesList(
  WidgetTester tester, {
  required List<PremiumFeatureItem> features,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: SingleChildScrollView(
          child: PremiumFeaturesList(features: features),
        ),
      ),
    ),
  );
}

void main() {
  group('PremiumFeaturesList', () {
    testWidgets('should display all feature titles', (tester) async {
      await pumpPremiumFeaturesList(tester, features: _testFeatures);

      expect(find.text('広告非表示'), findsOneWidget);
      expect(find.text('詳細統計'), findsOneWidget);
      expect(find.text('テーマカスタマイズ'), findsOneWidget);
    });

    testWidgets('should display all feature descriptions', (tester) async {
      await pumpPremiumFeaturesList(tester, features: _testFeatures);

      expect(find.text('全ての広告を非表示にします'), findsOneWidget);
      expect(find.text('習慣の詳細な統計データを表示します'), findsOneWidget);
      expect(find.text('アプリのテーマを自由に変更できます'), findsOneWidget);
    });

    testWidgets('should display icons for each feature', (tester) async {
      await pumpPremiumFeaturesList(tester, features: _testFeatures);

      expect(find.byIcon(BootstrapIcons.eyeSlash), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.graphUp), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.palette), findsOneWidget);
    });

    testWidgets('should display section header', (tester) async {
      await pumpPremiumFeaturesList(tester, features: _testFeatures);

      expect(find.text('プレミアム機能'), findsOneWidget);
    });

    testWidgets('should show empty message when features list is empty',
        (tester) async {
      await pumpPremiumFeaturesList(tester, features: const []);

      expect(find.text('プレミアム機能はありません'), findsOneWidget);
    });

    testWidgets('should render a single feature correctly', (tester) async {
      await pumpPremiumFeaturesList(
        tester,
        features: [_testFeatures[0]],
      );

      expect(find.text('広告非表示'), findsOneWidget);
      expect(find.text('全ての広告を非表示にします'), findsOneWidget);
      expect(find.byIcon(BootstrapIcons.eyeSlash), findsOneWidget);
    });
  });

  group('PremiumFeatureItem', () {
    test('should store title, description, and icon', () {
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
