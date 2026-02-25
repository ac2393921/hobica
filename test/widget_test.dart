import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hobica/app.dart';
import 'package:hobica/features/habit/presentation/providers/habit_list_provider.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';
import 'package:hobica/mocks/mock_overrides.dart';

void main() {
  testWidgets('app smoke test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          habitRepositoryProvider.overrideWithValue(MockHabitRepository()),
          ...mockRepositoryOverrides,
        ],
        child: const HobicaApp(),
      ),
    );

    expect(find.byType(HobicaApp), findsOneWidget);
  });
}
