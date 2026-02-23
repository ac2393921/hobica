import 'package:hobica/core/utils/date_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 月次カレンダーで達成日をハイライト表示する Presentational ウィジェット。
///
/// 7列グリッドで日付を並べ、[completedDates] に含まれる日はチェックアイコンを表示する。
class HabitCompletionCalendar extends StatelessWidget {
  const HabitCompletionCalendar({
    required this.completedDates,
    this.displayMonth,
    super.key,
  });

  static const int _daysInWeek = 7;
  static const double _cellSize = 36.0;
  static const double _iconSize = 20.0;

  /// 達成日の Set（date 正規化済み）。
  final Set<DateTime> completedDates;

  /// 表示する月。省略時は今月。
  final DateTime? displayMonth;

  DateTime get _month {
    final now = DateTime.now();
    return displayMonth ?? DateTime(now.year, now.month);
  }

  int _leadingEmptyCells(DateTime firstDay) =>
      (firstDay.weekday - 1) % _daysInWeek;

  List<DateTime?> _buildCalendarCells() {
    final firstDay = DateTime(_month.year, _month.month, 1);
    final daysInMonth =
        DateTime(_month.year, _month.month + 1, 0).day;

    final startPadding = _leadingEmptyCells(firstDay);

    final cells = <DateTime?>[];
    for (var i = 0; i < startPadding; i++) {
      cells.add(null);
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(DateTime(_month.year, _month.month, day));
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final cells = _buildCalendarCells();

    return GridView.count(
      crossAxisCount: _daysInWeek,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cells.map((date) {
        if (date == null) {
          return const SizedBox.shrink();
        }
        final isCompleted = completedDates.contains(date.toDate());
        return SizedBox(
          width: _cellSize,
          height: _cellSize,
          child: Center(
            child: isCompleted
                ? const Icon(
                    BootstrapIcons.checkCircleFill,
                    size: _iconSize,
                  )
                : Text(
                    '${date.day}',
                    textAlign: TextAlign.center,
                  ),
          ),
        );
      }).toList(),
    );
  }
}
