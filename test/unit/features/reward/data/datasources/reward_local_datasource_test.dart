import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/features/reward/data/datasources/reward_local_datasource.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late RewardLocalDataSource dataSource;

  setUp(() {
    db = _createInMemoryDb();
    dataSource = RewardLocalDataSource(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('RewardLocalDataSource', () {
    group('fetchAllActive', () {
      test('returns empty list when no rewards exist', () async {
        final rows = await dataSource.fetchAllActive();
        expect(rows, isEmpty);
      });

      test('returns only active rewards', () async {
        await dataSource.insert(title: 'Active', targetPoints: 100);
        final toDelete = await dataSource.insert(
          title: 'Inactive',
          targetPoints: 200,
        );
        await dataSource.softDelete(toDelete.id);

        final rows = await dataSource.fetchAllActive();
        expect(rows.length, 1);
        expect(rows.first.title, 'Active');
      });
    });

    group('fetchActiveById', () {
      test('returns row when active reward exists', () async {
        final inserted = await dataSource.insert(
          title: 'Test',
          targetPoints: 100,
        );

        final row = await dataSource.fetchActiveById(inserted.id);
        expect(row, isNotNull);
        expect(row!.title, 'Test');
        expect(row.targetPoints, 100);
      });

      test('returns null for non-existent id', () async {
        final row = await dataSource.fetchActiveById(999);
        expect(row, isNull);
      });

      test('returns null for soft-deleted reward', () async {
        final inserted = await dataSource.insert(
          title: 'Deleted',
          targetPoints: 100,
        );
        await dataSource.softDelete(inserted.id);

        final row = await dataSource.fetchActiveById(inserted.id);
        expect(row, isNull);
      });
    });

    group('insert', () {
      test('inserts a reward with required fields', () async {
        final row = await dataSource.insert(
          title: 'Movie',
          targetPoints: 200,
        );

        expect(row.title, 'Movie');
        expect(row.targetPoints, 200);
        expect(row.isActive, isTrue);
        expect(row.imageUri, isNull);
        expect(row.category, isNull);
        expect(row.memo, isNull);
      });

      test('inserts a reward with optional fields', () async {
        final row = await dataSource.insert(
          title: 'Cake',
          targetPoints: 100,
          category: 'food',
          memo: 'Delicious!',
          imageUri: 'https://example.com/cake.png',
        );

        expect(row.category, 'food');
        expect(row.memo, 'Delicious!');
        expect(row.imageUri, 'https://example.com/cake.png');
      });
    });

    group('update', () {
      test('updates an active reward and returns affected row count', () async {
        final inserted = await dataSource.insert(
          title: 'Old Title',
          targetPoints: 100,
        );

        final count = await dataSource.update(
          inserted.id,
          const RewardsCompanion(title: Value('New Title')),
        );

        expect(count, 1);

        final updated = await dataSource.fetchActiveById(inserted.id);
        expect(updated!.title, 'New Title');
      });

      test('returns 0 for non-existent reward', () async {
        final count = await dataSource.update(
          999,
          const RewardsCompanion(title: Value('Ghost')),
        );
        expect(count, 0);
      });

      test('returns 0 for soft-deleted reward', () async {
        final inserted = await dataSource.insert(
          title: 'Deleted',
          targetPoints: 100,
        );
        await dataSource.softDelete(inserted.id);

        final count = await dataSource.update(
          inserted.id,
          const RewardsCompanion(title: Value('Updated')),
        );
        expect(count, 0);
      });
    });

    group('softDelete', () {
      test('sets isActive to false and returns affected row count', () async {
        final inserted = await dataSource.insert(
          title: 'To Delete',
          targetPoints: 100,
        );

        final count = await dataSource.softDelete(inserted.id);
        expect(count, 1);

        final row = await dataSource.fetchActiveById(inserted.id);
        expect(row, isNull);
      });

      test('returns 0 for non-existent reward', () async {
        final count = await dataSource.softDelete(999);
        expect(count, 0);
      });

      test('returns 0 for already soft-deleted reward', () async {
        final inserted = await dataSource.insert(
          title: 'Deleted',
          targetPoints: 100,
        );
        await dataSource.softDelete(inserted.id);

        final count = await dataSource.softDelete(inserted.id);
        expect(count, 0);
      });
    });

    group('insertRedemption', () {
      test('inserts a redemption record', () async {
        final reward = await dataSource.insert(
          title: 'Nice Reward',
          targetPoints: 100,
        );

        final row = await dataSource.insertRedemption(
          rewardId: reward.id,
          pointsSpent: 100,
        );

        expect(row.rewardId, reward.id);
        expect(row.pointsSpent, 100);
      });
    });
  });
}
