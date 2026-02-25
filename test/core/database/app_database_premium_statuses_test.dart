import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

/// Drift stores DateTime as Unix epoch seconds, truncating sub-second precision.
DateTime _secondPrecision(DateTime dt) =>
    DateTime.fromMillisecondsSinceEpoch(
      (dt.millisecondsSinceEpoch ~/ 1000) * 1000,
    );

void main() {
  late AppDatabase db;

  setUp(() {
    db = _createInMemoryDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('PremiumStatuses table', () {
    test('inserts a row with default isPremium=false', () async {
      final now = _secondPrecision(DateTime.now());
      final id = await db
          .into(db.premiumStatuses)
          .insert(PremiumStatusesCompanion.insert(updatedAt: now));

      final row = await (db.select(db.premiumStatuses)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      expect(row.id, id);
      expect(row.isPremium, isFalse);
      expect(row.premiumExpiresAt, isNull);
      expect(row.purchaseToken, isNull);
      expect(row.updatedAt, now);
    });

    test('inserts a row with all fields populated', () async {
      final now = _secondPrecision(DateTime.now());
      final expiresAt =
          _secondPrecision(now.add(const Duration(days: 30)));
      const token = 'purchase-token-abc';

      final id = await db.into(db.premiumStatuses).insert(
            PremiumStatusesCompanion.insert(
              isPremium: const Value(true),
              premiumExpiresAt: Value(expiresAt),
              purchaseToken: const Value(token),
              updatedAt: now,
            ),
          );

      final row = await (db.select(db.premiumStatuses)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      expect(row.isPremium, isTrue);
      expect(row.premiumExpiresAt, expiresAt);
      expect(row.purchaseToken, token);
    });

    test('updates isPremium from false to true', () async {
      final now = _secondPrecision(DateTime.now());
      final id = await db
          .into(db.premiumStatuses)
          .insert(PremiumStatusesCompanion.insert(updatedAt: now));

      await (db.update(db.premiumStatuses)..where((t) => t.id.equals(id)))
          .write(const PremiumStatusesCompanion(isPremium: Value(true)));

      final row = await (db.select(db.premiumStatuses)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      expect(row.isPremium, isTrue);
    });

    test('deletes a row', () async {
      final now = _secondPrecision(DateTime.now());
      final id = await db
          .into(db.premiumStatuses)
          .insert(PremiumStatusesCompanion.insert(updatedAt: now));

      final deletedCount = await (db.delete(db.premiumStatuses)
            ..where((t) => t.id.equals(id)))
          .go();

      expect(deletedCount, 1);

      final rows = await db.select(db.premiumStatuses).get();
      expect(rows, isEmpty);
    });

    test('auto-increments id across multiple inserts', () async {
      final now = _secondPrecision(DateTime.now());

      final id1 = await db
          .into(db.premiumStatuses)
          .insert(PremiumStatusesCompanion.insert(updatedAt: now));
      final id2 = await db
          .into(db.premiumStatuses)
          .insert(PremiumStatusesCompanion.insert(updatedAt: now));

      expect(id2, greaterThan(id1));
    });
  });
}
