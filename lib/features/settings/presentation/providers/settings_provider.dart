import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/domain/repositories/settings_repository.dart';
import 'package:hobica/mocks/mock_settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return MockSettingsRepository();
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<AppSettings> build() async {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  Future<void> updateThemeMode(AppThemeMode mode) async {
    final settings =
        await ref.read(settingsRepositoryProvider).updateThemeMode(mode);
    state = AsyncValue.data(settings);
  }

  Future<void> updateNotificationEnabled({required bool enabled}) async {
    final settings = await ref
        .read(settingsRepositoryProvider)
        .updateNotificationEnabled(enabled: enabled);
    state = AsyncValue.data(settings);
  }
}
