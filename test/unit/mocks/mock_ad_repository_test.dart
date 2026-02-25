import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/mocks/mock_ad_repository.dart';

void main() {
  late MockAdRepository repository;

  setUp(() {
    repository = MockAdRepository();
  });

  group('MockAdRepository', () {
    group('loadBannerAd', () {
      test('returns true', () async {
        final result = await repository.loadBannerAd();

        expect(result, true);
      });
    });

    group('disposeBannerAd', () {
      test('does not throw', () {
        expect(() => repository.disposeBannerAd(), returnsNormally);
      });
    });

    group('reload after dispose', () {
      test('returns true after dispose and reload', () async {
        await repository.loadBannerAd();
        repository.disposeBannerAd();

        final result = await repository.loadBannerAd();
        expect(result, true);
      });
    });
  });
}
