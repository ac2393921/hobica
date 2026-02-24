import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/pages/habit_detail_page.dart';
import 'package:hobica/features/habit/presentation/pages/habit_form_page.dart';
import 'package:hobica/features/habit/presentation/pages/habit_list_page.dart';
import 'package:hobica/features/history/presentation/pages/history_page.dart';
import 'package:hobica/features/reward/presentation/pages/reward_detail_page.dart';
import 'package:hobica/features/reward/presentation/pages/reward_form_page.dart';
import 'package:hobica/features/reward/presentation/pages/reward_list_page.dart';
import 'package:hobica/features/settings/presentation/pages/settings_page.dart';

import 'routes.dart';

/// プレースホルダー画面
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'この画面は後続フェーズで実装されます',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// ボトムナビゲーション付きシェル
///
/// 5つのタブを持つボトムナビゲーションを実装。
/// フェーズ12.2でshadcn_flutterのTabsコンポーネントに置き換え予定。
class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: '習慣'),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'ご褒美',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '履歴'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
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
              builder: (context, state) => const _PlaceholderPage(title: 'ホーム'),
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
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('エラー')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('ページが見つかりません', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            state.uri.toString(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('ホームに戻る'),
          ),
        ],
      ),
    ),
  ),
);
