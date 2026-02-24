import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/settings/domain/models/app_settings.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:hobica/mocks/mock_settings_repository.dart';

void main() {
  late ProviderContainer container;
  late MockSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepository();
    container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SettingsNotifier', () {
    test('build returns default AppSettings from repository', () async {
      final settings = await container.read(settingsNotifierProvider.future);

      expect(settings, isA<AppSettings>());
      expect(settings.themeMode, AppThemeMode.system);
      expect(settings.notificationsEnabled, true);
    });

    test('updateThemeMode updates themeMode and reflects in state', () async {
      await container.read(settingsNotifierProvider.future);

      await container
          .read(settingsNotifierProvider.notifier)
          .updateThemeMode(AppThemeMode.dark);

      final settings = await container.read(settingsNotifierProvider.future);
      expect(settings.themeMode, AppThemeMode.dark);
    });

    test('updateNotificationEnabled to false updates state', () async {
      await container.read(settingsNotifierProvider.future);

      await container
          .read(settingsNotifierProvider.notifier)
          .updateNotificationEnabled(enabled: false);

      final settings = await container.read(settingsNotifierProvider.future);
      expect(settings.notificationsEnabled, false);
    });

    test('updateNotificationEnabled to true updates state', () async {
      await container.read(settingsNotifierProvider.future);
      await container
          .read(settingsNotifierProvider.notifier)
          .updateNotificationEnabled(enabled: false);

      await container
          .read(settingsNotifierProvider.notifier)
          .updateNotificationEnabled(enabled: true);

      final settings = await container.read(settingsNotifierProvider.future);
      expect(settings.notificationsEnabled, true);
    });

    test('updateThemeMode to light changes themeMode', () async {
      await container.read(settingsNotifierProvider.future);

      await container
          .read(settingsNotifierProvider.notifier)
          .updateThemeMode(AppThemeMode.light);

      final settings = await container.read(settingsNotifierProvider.future);
      expect(settings.themeMode, AppThemeMode.light);
    });
  });
}
