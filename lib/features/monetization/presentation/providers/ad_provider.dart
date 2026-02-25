import 'package:hobica/features/monetization/domain/repositories/ad_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ad_provider.g.dart';

@riverpod
AdRepository adRepository(AdRepositoryRef ref) {
  throw UnimplementedError(
    'adRepositoryProvider must be overridden in ProviderScope',
  );
}

@riverpod
class AdNotifier extends _$AdNotifier {
  @override
  Future<bool> build() async {
    final repository = ref.watch(adRepositoryProvider);
    ref.onDispose(repository.disposeBannerAd);
    return repository.loadBannerAd();
  }
}
