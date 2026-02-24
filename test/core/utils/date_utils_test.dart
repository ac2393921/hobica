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

    group('toJaDateLabel', () {
      test('正常系: 年月日を日本語形式で返す', () {
        final dt = DateTime(2026, 12, 31);
        expect(dt.toJaDateLabel(), equals('2026年12月31日'));
      });

      test('1桁の月・日もゼロ埋めせず返す', () {
        final dt = DateTime(2026, 1, 5);
        expect(dt.toJaDateLabel(), equals('2026年1月5日'));
      });
    });
  });

  group('groupByDate', () {
    test('空リストを渡すと空のマップを返す', () {
      final result = groupByDate<String>([], (_) => DateTime(2026, 1, 1));
      expect(result, isEmpty);
    });

    test('同じ日付・異なる時刻の要素は同じキーにまとめられる', () {
      final morning = DateTime(2026, 2, 22, 9);
      final night = DateTime(2026, 2, 22, 23, 59);
      final result = groupByDate(['a', 'b'], (s) => s == 'a' ? morning : night);
      expect(result.length, equals(1));
      expect(result[DateTime(2026, 2, 22)], equals(['a', 'b']));
    });

    test('異なる日付の要素はそれぞれ別のキーに分けられる', () {
      final day1 = DateTime(2026, 2, 22);
      final day2 = DateTime(2026, 2, 23);
      final result = groupByDate(['a', 'b'], (s) => s == 'a' ? day1 : day2);
      expect(result.length, equals(2));
      expect(result[DateTime(2026, 2, 22)], equals(['a']));
      expect(result[DateTime(2026, 2, 23)], equals(['b']));
    });

    test('単一要素のリストでも正しく動作する', () {
      final result = groupByDate(['x'], (_) => DateTime(2026, 3, 1));
      expect(result.length, equals(1));
      expect(result[DateTime(2026, 3, 1)], equals(['x']));
    });
  });
}
