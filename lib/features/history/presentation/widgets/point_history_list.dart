import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/history/presentation/widgets/point_history_item.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PointHistoryList extends ConsumerWidget {
  const PointHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointHistoryProvider);
    return state.when(
      loading: () => const LoadingIndicator(),
      error: (_, __) => ErrorView(
        message: 'ポイント履歴の取得に失敗しました',
        onRetry: () => ref.invalidate(pointHistoryProvider),
      ),
      data: (logs) {
        if (logs.isEmpty) {
          return const EmptyView(message: 'ポイント獲得履歴はありません');
        }
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (_, index) => PointHistoryItem(log: logs[index]),
        );
      },
    );
  }
}
