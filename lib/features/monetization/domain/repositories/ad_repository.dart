abstract interface class AdRepository {
  Future<bool> loadBannerAd();

  void disposeBannerAd();
}
