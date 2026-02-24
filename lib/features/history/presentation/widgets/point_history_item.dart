import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PointHistoryItem extends StatelessWidget {
  const PointHistoryItem({required this.log, super.key});

  static const double _cardPadding = 16;
  static const double _dateHabitSpacing = 4;

  final HabitLog log;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(_cardPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('yyyy/MM/dd').format(log.date)),
                  const SizedBox(height: _dateHabitSpacing),
                  Text('習慣ID: ${log.habitId}'),
                ],
              ),
            ),
            PrimaryBadge(child: Text('+${log.points}pt')),
          ],
        ),
      ),
    );
  }
}
