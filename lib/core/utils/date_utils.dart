extension DateTimeExtension on DateTime {
  /// 時刻コンポーネントを除いた日付のみの [DateTime] を返す。
  ///
  /// 習慣達成の重複チェックにおける日付比較に使用する。
  DateTime toDate() {
    return DateTime(year, month, day);
  }
}
