extension DateTimeExtension on DateTime {
  // 習慣達成の重複チェックにおける日付比較に使用する。
  DateTime toDate() {
    return DateTime(year, month, day);
  }

  String toJaDateLabel() {
    return '$year年$month月$day日';
  }
}

Map<DateTime, List<T>> groupByDate<T>(
  List<T> items,
  DateTime Function(T) getDate,
) {
  final result = <DateTime, List<T>>{};
  for (final item in items) {
    final date = getDate(item).toDate();
    result.putIfAbsent(date, () => []).add(item);
  }
  return result;
}
