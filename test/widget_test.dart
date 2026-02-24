import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hobica/app.dart';

void main() {
  testWidgets('app smoke test', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HobicaApp(),
      ),
    );

    expect(find.byType(HobicaApp), findsOneWidget);
  });
}
