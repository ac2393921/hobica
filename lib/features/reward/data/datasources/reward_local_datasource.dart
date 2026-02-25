import 'package:drift/drift.dart';
import 'package:hobica/core/database/app_database.dart';

class RewardLocalDataSource {
  const RewardLocalDataSource(this._db);

  final AppDatabase _db;

  Future<List<RewardRow>> fetchAllActive() async {
    return (_db.select(_db.rewards)
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  Future<RewardRow?> fetchActiveById(int id) async {
    return (_db.select(_db.rewards)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<RewardRow> insert({
    required String title,
    required int targetPoints,
    String? imageUri,
    String? category,
    String? memo,
  }) {
    return _db.into(_db.rewards).insertReturning(
          RewardsCompanion.insert(
            title: title,
            targetPoints: targetPoints,
            imageUri: Value(imageUri),
            category: Value(category),
            memo: Value(memo),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<int> update(int id, RewardsCompanion companion) {
    return (_db.update(_db.rewards)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .write(companion);
  }

  Future<int> softDelete(int id) {
    return (_db.update(_db.rewards)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .write(const RewardsCompanion(isActive: Value(false)));
  }

  Future<RewardRedemptionRow> insertRedemption({
    required int rewardId,
    required int pointsSpent,
  }) {
    return _db.into(_db.rewardRedemptions).insertReturning(
          RewardRedemptionsCompanion.insert(
            rewardId: rewardId,
            pointsSpent: pointsSpent,
            redeemedAt: DateTime.now(),
          ),
        );
  }
}
