import 'package:hobica/features/monetization/domain/repositories/ad_repository.dart';

class MockAdRepository implements AdRepository {
  @override
  Future<bool> loadBannerAd() async => true;

  @override
  void disposeBannerAd() {}
}
