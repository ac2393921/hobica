import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/database/providers/database_provider.dart';
import 'package:hobica/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<AppSettings> build() async {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.getSettings();
  }

  Future<void> updateThemeMode(AppThemeMode themeMode) async {
    final repository = ref.read(settingsRepositoryProvider);
    final settings = await repository.updateThemeMode(themeMode);
    state = AsyncValue.data(settings);
  }

  Future<void> updateNotificationEnabled({required bool enabled}) async {
    final repository = ref.read(settingsRepositoryProvider);
    final settings =
        await repository.updateNotificationEnabled(enabled: enabled);
    state = AsyncValue.data(settings);
  }
}
