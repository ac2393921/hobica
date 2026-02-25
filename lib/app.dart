import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/router/router.dart';
import 'package:hobica/features/settings/domain/models/app_theme_mode.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// hobica のルートウィジェット。
///
/// [ConsumerWidget] を継承し、[settingsNotifierProvider] からテーマモードを
/// 取得して shadcn_flutter テーマに反映する。
/// 設定の読み込み中はシステムテーマを使用し、読み込み完了後に
/// ユーザー設定のテーマに切り替わる。
class HobicaApp extends ConsumerWidget {
  const HobicaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      settingsNotifierProvider.select(
        (asyncSettings) => asyncSettings.whenOrNull(
          data: (settings) => settings.themeMode.toFlutterThemeMode(),
        ),
      ),
    );

    return ShadcnApp.router(
      title: 'Hobica',
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorSchemes.slate(ThemeMode.light),
        radius: 0.5,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorSchemes.slate(ThemeMode.dark),
        radius: 0.5,
      ),
      themeMode: themeMode ?? ThemeMode.system,
    );
  }
}

/// [AppThemeMode] を Flutter の [ThemeMode] に変換する拡張。
extension AppThemeModeX on AppThemeMode {
  ThemeMode toFlutterThemeMode() {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
