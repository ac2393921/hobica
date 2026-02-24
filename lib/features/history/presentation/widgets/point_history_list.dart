import 'package:hobica/core/utils/date_utils.dart';
import 'package:hobica/core/widgets.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PointHistoryList extends StatelessWidget {
  const PointHistoryList({
    required this.habitLogs,
    super.key,
  });

  final List<HabitLog> habitLogs;

  @override
  Widget build(BuildContext context) {
    if (habitLogs.isEmpty) {
      return const EmptyView(message: 'ポイント獲得履歴がありません');
    }

    final grouped = groupByDate(habitLogs, (log) => log.date);
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final logs = grouped[date]!;
        return _DateGroup(date: date, logs: logs);
      },
    );
  }
}

class _DateGroup extends StatelessWidget {
  const _DateGroup({
    required this.date,
    required this.logs,
  });

  final DateTime date;
  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            date.toJaDateLabel(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        for (final log in logs) _PointHistoryItem(log: log),
      ],
    );
  }
}

class _PointHistoryItem extends StatelessWidget {
  const _PointHistoryItem({required this.log});

  final HabitLog log;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('習慣 #${log.habitId}'),
          Text(
            '+${log.points}pt',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
