import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/monetization/presentation/widgets/ad_banner_widget.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final _testTheme = ThemeData(
  colorScheme: ColorSchemes.slate(ThemeMode.light),
  radius: 0.5,
);

Future<void> pumpAdBannerWidget(
  WidgetTester tester, {
  double? height,
}) async {
  await tester.pumpWidget(
    ShadcnApp(
      theme: _testTheme,
      home: Scaffold(
        child: AdBannerWidget(
          height: height ?? AdBannerWidget.defaultHeight,
        ),
      ),
    ),
  );
}

void main() {
  group('AdBannerWidget', () {
    testWidgets('should render the widget', (tester) async {
      await pumpAdBannerWidget(tester);

      expect(find.byType(AdBannerWidget), findsOneWidget);
    });

    testWidgets('should display the ad label text', (tester) async {
      await pumpAdBannerWidget(tester);

      expect(find.text('広告'), findsOneWidget);
    });

    testWidgets('should display the megaphone icon', (tester) async {
      await pumpAdBannerWidget(tester);

      expect(find.byIcon(BootstrapIcons.megaphone), findsOneWidget);
    });

    testWidgets('should have Semantics with label', (tester) async {
      await pumpAdBannerWidget(tester);

      final semantics = tester.getSemantics(find.byType(AdBannerWidget));
      expect(semantics.label, '広告');
    });

    testWidgets('should apply custom height', (tester) async {
      const customHeight = 100.0;
      await pumpAdBannerWidget(tester, height: customHeight);

      final container = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AdBannerWidget),
          matching: find.byType(SizedBox).first,
        ),
      );
      expect(container.height, customHeight);
    });
  });
}
