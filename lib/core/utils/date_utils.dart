extension DateTimeExtension on DateTime {
  // 習慣達成の重複チェックにおける日付比較に使用する。
  DateTime toDate() {
    return DateTime(year, month, day);
  }
}
