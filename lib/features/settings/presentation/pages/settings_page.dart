import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:hobica/features/settings/presentation/widgets/theme_switcher.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const double _pagePadding = 16;
  static const double _cardPadding = 16;
  static const double _labelWidgetSpacing = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      headers: const [AppBar(title: Text('設定'))],
      child: settingsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (settings) => ListView(
          padding: const EdgeInsets.all(_pagePadding),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(_cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('テーマ'),
                    const SizedBox(height: _labelWidgetSpacing),
                    ThemeSwitcher(
                      currentMode: settings.themeMode,
                      onChanged: (mode) => ref
                          .read(settingsNotifierProvider.notifier)
                          .updateThemeMode(mode),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
