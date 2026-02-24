import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/router/routes.dart';
import 'package:hobica/core/widgets/empty_view.dart';
import 'package:hobica/core/widgets/error_view.dart';
import 'package:hobica/core/widgets/loading_indicator.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_card.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardListPage extends ConsumerWidget {
  const RewardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardsAsync = ref.watch(rewardListProvider);
    final walletAsync = ref.watch(walletBalanceProvider);

    return Scaffold(
      headers: [
        AppBar(
          title: const Text('ご褒美'),
          trailing: [
            Button.ghost(
              onPressed: () =>
                  context.pushNamed(AppRouteNames.rewardForm),
              child: const Icon(BootstrapIcons.plusLg),
            ),
          ],
        ),
      ],
      child: rewardsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(rewardListProvider),
        ),
        data: (rewards) {
          if (rewards.isEmpty) {
            return EmptyView(
              message: 'ご褒美がまだありません',
              icon: BootstrapIcons.gift,
              onAction: () =>
                  context.pushNamed(AppRouteNames.rewardForm),
              actionText: '追加',
            );
          }

          return walletAsync.when(
            loading: () => const LoadingIndicator(),
            error: (error, _) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(walletBalanceProvider),
            ),
            data: (wallet) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rewards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return RewardCard(
                  reward: reward,
                  currentPoints: wallet.currentPoints,
                  onTap: () => context.pushNamed(
                    AppRouteNames.rewardDetail,
                    pathParameters: {
                      AppRouteParams.id: reward.id.toString(),
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
