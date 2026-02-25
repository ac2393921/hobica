import 'package:go_router/go_router.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/pages/habit_detail_page.dart';
import 'package:hobica/features/habit/presentation/pages/habit_form_page.dart';
import 'package:hobica/features/habit/presentation/pages/habit_list_page.dart';
import 'package:hobica/features/history/presentation/pages/history_page.dart';
import 'package:hobica/features/home/presentation/pages/home_page.dart';
import 'package:hobica/features/reward/presentation/pages/reward_detail_page.dart';
import 'package:hobica/features/reward/presentation/pages/reward_form_page.dart';
import 'package:hobica/features/reward/presentation/pages/reward_list_page.dart';
import 'package:hobica/features/settings/presentation/pages/settings_page.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'routes.dart';

const double _infoIconSize = 64;
const double _infoTitleSpacing = 16;
const double _infoSubtitleSpacing = 8;
const double _infoButtonSpacing = 24;

/// プレースホルダー画面
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      headers: [AppBar(title: Text(title))],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              BootstrapIcons.tools,
              size: _infoIconSize,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(height: _infoTitleSpacing),
            Text(title, style: theme.typography.h4),
            const SizedBox(height: _infoSubtitleSpacing),
            Text(
              'この画面は後続フェーズで実装されます',
              style: TextStyle(color: theme.colorScheme.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

/// ボトムナビゲーション付きシェル
///
/// 5つのタブを持つshadcn_flutter NavigationBarを実装。
class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      footers: [
        NavigationBar(
          index: _calculateSelectedIndex(context),
          onSelected: (index) => _onItemTapped(index, context),
          labelType: NavigationLabelType.all,
          children: const [
            NavigationButton(
              label: Text('ホーム'),
              child: Icon(BootstrapIcons.house),
            ),
            NavigationButton(
              label: Text('習慣'),
              child: Icon(BootstrapIcons.checkCircle),
            ),
            NavigationButton(
              label: Text('ご褒美'),
              child: Icon(BootstrapIcons.gift),
            ),
            NavigationButton(
              label: Text('履歴'),
              child: Icon(BootstrapIcons.clockHistory),
            ),
            NavigationButton(
              label: Text('設定'),
              child: Icon(BootstrapIcons.gear),
            ),
          ],
        ),
      ],
      child: child,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.habits)) return 1;
    if (location.startsWith(AppRoutes.rewards)) return 2;
    if (location.startsWith(AppRoutes.history)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.habits);
      case 2:
        context.go(AppRoutes.rewards);
      case 3:
        context.go(AppRoutes.history);
      case 4:
        context.go(AppRoutes.settings);
    }
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _ScaffoldWithNavBar(child: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: AppRouteNames.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.habits,
              name: AppRouteNames.habitList,
              builder: (context, state) => const HabitListPage(),
              routes: [
                // 習慣作成（newルートは:idより前に配置する必要がある）
                GoRoute(
                  path: 'new',
                  name: AppRouteNames.habitForm,
                  builder: (context, state) => const HabitFormPage(),
                ),
                GoRoute(
                  path: ':${AppRouteParams.id}',
                  name: AppRouteNames.habitDetail,
                  builder: (context, state) => HabitDetailPage(
                    habitId: int.parse(
                      state.pathParameters[AppRouteParams.id]!,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: AppRouteNames.habitEdit,
                      builder: (context, state) =>
                          HabitFormPage(initialHabit: state.extra as Habit?),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.rewards,
              name: AppRouteNames.rewardList,
              builder: (context, state) => const RewardListPage(),
              routes: [
                // ご褒美作成（newルートは:idより前に配置する必要がある）
                GoRoute(
                  path: 'new',
                  name: AppRouteNames.rewardForm,
                  builder: (context, state) => const RewardFormPage(),
                ),
                GoRoute(
                  path: ':${AppRouteParams.id}',
                  name: AppRouteNames.rewardDetail,
                  builder: (context, state) {
                    final id = int.parse(
                      state.pathParameters[AppRouteParams.id]!,
                    );
                    return RewardDetailPage(rewardId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: AppRouteNames.rewardEdit,
                      builder: (context, state) {
                        final id = int.parse(
                          state.pathParameters[AppRouteParams.id]!,
                        );
                        return RewardFormPage(rewardId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.history,
              name: AppRouteNames.history,
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              name: AppRouteNames.settings,
              builder: (context, state) => const SettingsPage(),
              routes: [
                GoRoute(
                  path: 'premium',
                  name: AppRouteNames.premium,
                  builder: (context, state) =>
                      const _PlaceholderPage(title: 'プレミアム'),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    final theme = Theme.of(context);

    return Scaffold(
      headers: const [AppBar(title: Text('エラー'))],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              BootstrapIcons.exclamationCircle,
              size: _infoIconSize,
              color: theme.colorScheme.destructive,
            ),
            const SizedBox(height: _infoTitleSpacing),
            Text('ページが見つかりません', style: theme.typography.h4),
            const SizedBox(height: _infoSubtitleSpacing),
            Text(
              state.uri.toString(),
              style: TextStyle(color: theme.colorScheme.mutedForeground),
            ),
            const SizedBox(height: _infoButtonSpacing),
            Button.primary(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      ),
    );
  },
);
