import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/monetization/presentation/providers/ad_provider.dart';
import 'package:hobica/mocks/mock_ad_repository.dart';

void main() {
  group('adRepositoryProvider', () {
    test('throws UnimplementedError by default', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(adRepositoryProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('AdNotifier', () {
    group('build', () {
      test('loads banner ad and returns true', () async {
        final container = ProviderContainer(
          overrides: [
            adRepositoryProvider.overrideWithValue(MockAdRepository()),
          ],
        );
        addTearDown(container.dispose);

        final result = await container.read(adNotifierProvider.future);

        expect(result, true);
      });
    });
  });
}
