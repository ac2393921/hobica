import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/history/presentation/widgets/redemption_history_item.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RedemptionHistoryList extends ConsumerWidget {
  const RedemptionHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(redemptionHistoryProvider);
    return state.when(
      loading: () => const LoadingIndicator(),
      error: (_, __) => ErrorView(
        message: '交換履歴の取得に失敗しました',
        onRetry: () => ref.invalidate(redemptionHistoryProvider),
      ),
      data: (redemptions) {
        if (redemptions.isEmpty) {
          return const EmptyView(message: '交換履歴はありません');
        }
        return ListView.builder(
          itemCount: redemptions.length,
          itemBuilder: (_, index) =>
              RedemptionHistoryItem(redemption: redemptions[index]),
        );
      },
    );
  }
}
