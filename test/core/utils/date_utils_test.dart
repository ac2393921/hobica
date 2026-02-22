import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/utils/date_utils.dart';

void main() {
  group('DateTimeExtension', () {
    group('toDate', () {
      test('時刻が 00:00:00 に正規化される', () {
        final dt = DateTime(2026, 2, 22, 13, 45, 30);
        final result = dt.toDate();
        expect(result, equals(DateTime(2026, 2, 22)));
      });

      test('日付（年・月・日）が保持される', () {
        final dt = DateTime(2026, 2, 22, 13, 45, 30);
        final result = dt.toDate();
        expect(result.year, equals(2026));
        expect(result.month, equals(2));
        expect(result.day, equals(22));
      });

      test('時刻が既に 00:00:00 の場合もそのまま返る', () {
        final dt = DateTime(2026, 2, 22);
        final result = dt.toDate();
        expect(result, equals(DateTime(2026, 2, 22)));
      });

      test('異なる時刻の同じ日付が toDate() 後に等値になる', () {
        final morning = DateTime(2026, 2, 22, 9).toDate();
        final night = DateTime(2026, 2, 22, 23, 59).toDate();
        expect(morning, equals(night));
      });
    });
  });
}
