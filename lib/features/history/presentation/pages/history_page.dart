import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/history/presentation/providers/history_provider.dart';
import 'package:hobica/features/history/presentation/widgets/point_history_list.dart';
import 'package:hobica/features/history/presentation/widgets/redemption_history_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      headers: const [AppBar(title: Text('履歴'))],
      child: historyAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (history) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Tabs(
                index: _tabIndex,
                onChanged: (index) => setState(() => _tabIndex = index),
                tabs: const [
                  Text('ポイント獲得'),
                  Text('交換'),
                ],
              ),
            ),
            Expanded(
              child: _tabIndex == 0
                  ? PointHistoryList(habitLogs: history.habitLogs)
                  : RedemptionHistoryList(redemptions: history.redemptions),
            ),
          ],
        ),
      ),
    );
  }
}
