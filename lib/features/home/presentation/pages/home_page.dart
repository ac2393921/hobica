import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/router/routes.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/presentation/providers/habit_completion_provider.dart';
import 'package:hobica/features/home/presentation/providers/home_provider.dart';
import 'package:hobica/features/home/presentation/widgets/today_habits_section.dart';
import 'package:hobica/features/home/presentation/widgets/top_rewards_section.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// ホーム画面。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const double _contentPadding = 16;
  static const double _sectionSpacing = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeProvider);
    final walletAsync = ref.watch(walletBalanceProvider);
    final completionState = ref.watch(habitCompletionProvider);

    return Scaffold(
      headers: [
        AppBar(
          title: const Text('ホーム'),
          trailing: [
            walletAsync.when(
              data: (wallet) =>
                  PrimaryBadge(child: Text('${wallet.currentPoints}pt')),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const IconButton.ghost(
              icon: Icon(BootstrapIcons.bell),
            ),
            const IconButton.ghost(
              icon: Icon(BootstrapIcons.gear),
            ),
          ],
        ),
      ],
      child: homeAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(homeProvider),
        ),
        data: (homeState) => walletAsync.when(
          loading: () => const LoadingIndicator(),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(walletBalanceProvider),
          ),
          data: (wallet) => ListView(
            padding: const EdgeInsets.all(_contentPadding),
            children: [
              TodayHabitsSection(
                habits: homeState.activeHabits,
                completedIds: {
                  ...homeState.completedHabitIds,
                  ...completionState,
                },
                onComplete: (habitId) => ref
                    .read(habitCompletionProvider.notifier)
                    .completeHabit(habitId),
                onAddHabit: () => context.goNamed(AppRouteNames.habitForm),
              ),
              const SizedBox(height: _sectionSpacing),
              TopRewardsSection(
                rewards: homeState.topRewards,
                currentPoints: wallet.currentPoints,
                onSeeAll: () => context.go(AppRoutes.rewards),
                onRewardTap: (id) => context.pushNamed(
                  AppRouteNames.rewardDetail,
                  pathParameters: {AppRouteParams.id: id.toString()},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
