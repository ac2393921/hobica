import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/router/routes.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/settings/presentation/providers/settings_provider.dart';
import 'package:hobica/features/settings/presentation/widgets/theme_switcher.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 設定画面。
///
/// テーマ・通知・プレミアム・データ操作・その他リンクのセクションを提供する。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      headers: const [AppBar(title: Text('設定'))],
      child: settingsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(settingsNotifierProvider),
        ),
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            const _SectionHeader(title: 'テーマ'),
            _SettingsListTile(
              icon: BootstrapIcons.moonFill,
              label: 'テーマモード',
              trailing: ThemeSwitcher(
                currentMode: settings.themeMode,
                onChanged: (mode) => ref
                    .read(settingsNotifierProvider.notifier)
                    .updateThemeMode(mode),
              ),
            ),
            const _SectionHeader(title: '通知'),
            _SettingsListTile(
              icon: BootstrapIcons.bell,
              label: 'リマインド通知',
              trailing: Switch(
                value: settings.notificationsEnabled,
                onChanged: (enabled) => ref
                    .read(settingsNotifierProvider.notifier)
                    .updateNotificationEnabled(enabled: enabled),
              ),
            ),
            const _SectionHeader(title: 'プレミアム'),
            _SettingsListTile(
              icon: BootstrapIcons.star,
              label: 'プレミアムにアップグレード',
              trailing: const Icon(BootstrapIcons.chevronRight),
              onTap: () => context.goNamed(AppRouteNames.premium),
            ),
            const _SectionHeader(title: 'データ'),
            const _SettingsListTile(
              icon: BootstrapIcons.fileArrowDown,
              label: 'データをエクスポート',
              trailing: Icon(BootstrapIcons.chevronRight),
            ),
            const _SettingsListTile(
              icon: BootstrapIcons.fileArrowUp,
              label: 'データをインポート',
              trailing: Icon(BootstrapIcons.chevronRight),
            ),
            const _SectionHeader(title: 'その他'),
            const _SettingsListTile(
              icon: BootstrapIcons.fileEarmark,
              label: '利用規約',
              trailing: Icon(BootstrapIcons.chevronRight),
            ),
            const _SettingsListTile(
              icon: BootstrapIcons.shieldCheck,
              label: 'プライバシーポリシー',
              trailing: Icon(BootstrapIcons.chevronRight),
            ),
            const _SettingsListTile(
              icon: BootstrapIcons.infoCircle,
              label: 'アプリについて',
              trailing: Icon(BootstrapIcons.chevronRight),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: theme.typography.small.copyWith(
          color: theme.colorScheme.mutedForeground,
        ),
      ),
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  const _SettingsListTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
