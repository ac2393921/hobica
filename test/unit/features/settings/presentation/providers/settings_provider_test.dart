import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
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
    test('requires appDatabaseProvider override for default usage', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(settingsRepositoryProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('SettingsNotifier', () {
    group('build', () {
      test('loads initial settings state via getSettings', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final state = await container.read(settingsNotifierProvider.future);

        expect(state.id, 1);
        expect(state.themeMode, AppThemeMode.system);
        expect(state.notificationsEnabled, true);
        expect(state.locale, 'ja');
      });
    });

    group('updateThemeMode', () {
      test('updates themeMode and reflects in state', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(settingsNotifierProvider.future);
        await container
            .read(settingsNotifierProvider.notifier)
            .updateThemeMode(AppThemeMode.dark);

        final state = container.read(settingsNotifierProvider).value!;
        expect(state.themeMode, AppThemeMode.dark);
      });
    });

    group('updateNotificationEnabled', () {
      test('updates notificationsEnabled and reflects in state', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(settingsNotifierProvider.future);
        await container
            .read(settingsNotifierProvider.notifier)
            .updateNotificationEnabled(enabled: false);

        final state = container.read(settingsNotifierProvider).value!;
        expect(state.notificationsEnabled, false);
      });
    });
  });
}
