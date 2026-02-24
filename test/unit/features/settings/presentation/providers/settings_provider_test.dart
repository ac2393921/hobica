import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/domain/repositories/settings_repository.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:hobica/mocks/mock_settings_repository.dart';

ProviderContainer _makeContainer() {
  return ProviderContainer(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(MockSettingsRepository()),
    ],
  );
}

void main() {
  group('settingsRepositoryProvider', () {
    test('provides a SettingsRepository instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(settingsRepositoryProvider);
      expect(repo, isA<SettingsRepository>());
    });
  });

  group('SettingsNotifier', () {
    group('build', () {
      test('loads initial settings with system theme mode', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final settings = await container.read(settingsNotifierProvider.future);

        expect(settings, isA<AppSettings>());
        expect(settings.themeMode, AppThemeMode.system);
      });
    });

    group('updateThemeMode', () {
      test('updates state to dark after updateThemeMode(dark)', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(settingsNotifierProvider.future);
        await container
            .read(settingsNotifierProvider.notifier)
            .updateThemeMode(AppThemeMode.dark);

        final settings = container.read(settingsNotifierProvider).value!;
        expect(settings.themeMode, AppThemeMode.dark);
      });

      test('updates state to light after updateThemeMode(light)', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(settingsNotifierProvider.future);
        await container
            .read(settingsNotifierProvider.notifier)
            .updateThemeMode(AppThemeMode.light);

        final settings = container.read(settingsNotifierProvider).value!;
        expect(settings.themeMode, AppThemeMode.light);
      });

      test('consecutive updates reflect the last mode', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(settingsNotifierProvider.future);
        await container
            .read(settingsNotifierProvider.notifier)
            .updateThemeMode(AppThemeMode.dark);
        await container
            .read(settingsNotifierProvider.notifier)
            .updateThemeMode(AppThemeMode.light);

        final settings = container.read(settingsNotifierProvider).value!;
        expect(settings.themeMode, AppThemeMode.light);
      });
    });
  });
}
