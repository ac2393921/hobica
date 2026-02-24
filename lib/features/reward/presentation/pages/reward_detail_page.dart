import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/router/routes.dart';
import 'package:hobica/core/widgets/error_view.dart';
import 'package:hobica/core/widgets/loading_indicator.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/features/reward/presentation/utils/reward_category_labels.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_image_view.dart';
import 'package:hobica/features/reward/presentation/widgets/reward_progress_bar.dart';
import 'package:hobica/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardDetailPage extends ConsumerWidget {
  const RewardDetailPage({required this.rewardId, super.key});

  final int rewardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardsAsync = ref.watch(rewardListProvider);
    final walletAsync = ref.watch(walletBalanceProvider);

    return rewardsAsync.when(
      loading: () => Scaffold(
        headers: [AppBar(title: const Text('ご褒美詳細'))],
        child: const LoadingIndicator(),
      ),
      error: (error, _) => Scaffold(
        headers: [AppBar(title: const Text('ご褒美詳細'))],
        child: ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(rewardListProvider),
        ),
      ),
      data: (rewards) {
        final reward = rewards.where((r) => r.id == rewardId).firstOrNull;

        if (reward == null) {
          return Scaffold(
            headers: [AppBar(title: const Text('ご褒美詳細'))],
            child: ErrorView(message: 'ご褒美が見つかりません'),
          );
        }

        return walletAsync.when(
          loading: () => Scaffold(
            headers: [
              AppBar(
                title: Text(reward.title),
                trailing: [_buildEditButton(context, reward)],
              ),
            ],
            child: const LoadingIndicator(),
          ),
          error: (error, _) => Scaffold(
            headers: [
              AppBar(
                title: Text(reward.title),
                trailing: [_buildEditButton(context, reward)],
              ),
            ],
            child: ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(walletBalanceProvider),
            ),
          ),
          data: (wallet) => Scaffold(
            headers: [
              AppBar(
                title: Text(reward.title),
                trailing: [_buildEditButton(context, reward)],
              ),
            ],
            child: _RewardDetailContent(
              reward: reward,
              currentPoints: wallet.currentPoints,
              onRedeem: () => _handleRedeem(context, ref, reward),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditButton(BuildContext context, Reward reward) {
    return Button.ghost(
      onPressed: () => context.pushNamed(
        AppRouteNames.rewardEdit,
        pathParameters: {
          AppRouteParams.id: reward.id.toString(),
        },
      ),
      child: const Icon(BootstrapIcons.pencil),
    );
  }

  Future<void> _handleRedeem(
    BuildContext context,
    WidgetRef ref,
    Reward reward,
  ) async {
    final walletBalance = ref.read(walletBalanceProvider).valueOrNull;
    if (walletBalance == null) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('交換失敗'),
            content: const Text('ウォレット情報が取得できませんでした'),
            actions: [
              Button.ghost(
                onPressed: () => context.pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );
      }
      return;
    }

    try {
      await ref
          .read(rewardListProvider.notifier)
          .redeemReward(reward.id, walletBalance.currentPoints);
      ref.invalidate(walletBalanceProvider);
      if (context.mounted) context.pop();
    } catch (e) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('交換失敗'),
            content: Text(e.toString()),
            actions: [
              Button.ghost(
                onPressed: () => context.pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );
      }
    }
  }
}

class _RewardDetailContent extends StatelessWidget {
  const _RewardDetailContent({
    required this.reward,
    required this.currentPoints,
    required this.onRedeem,
  });

  final Reward reward;
  final int currentPoints;
  final VoidCallback onRedeem;

  bool get _canRedeem => currentPoints >= reward.targetPoints;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RewardImageView(
            imageUri: reward.imageUri,
            height: 200,
            iconSize: 64,
          ),
          const SizedBox(height: 16),
          Text(reward.title),
          const SizedBox(height: 8),
          if (reward.category != null)
            PrimaryBadge(
              child: Text(rewardCategoryLabels[reward.category!]!),
            ),
          const SizedBox(height: 8),
          Text('必要ポイント: ${reward.targetPoints} pt'),
          const SizedBox(height: 4),
          Text('現在のポイント: $currentPoints pt'),
          const SizedBox(height: 16),
          RewardProgressBar(
            currentPoints: currentPoints,
            targetPoints: reward.targetPoints,
          ),
          if (reward.memo != null && reward.memo!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(reward.memo!),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Button.primary(
              onPressed: _canRedeem ? onRedeem : null,
              child: const Text('交換する'),
            ),
          ),
        ],
      ),
    );
  }
}
