import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/data/datasources/reward_local_datasource.dart';
import 'package:hobica/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late RewardLocalDataSource dataSource;
  late RewardRepositoryImpl repo;

  setUp(() {
    db = _createInMemoryDb();
    dataSource = RewardLocalDataSource(db);
    repo = RewardRepositoryImpl(dataSource);
  });

  tearDown(() async {
    await db.close();
  });

  group('RewardRepositoryImpl', () {
    group('fetchAllRewards', () {
      test('returns empty list when no rewards exist', () async {
        final rewards = await repo.fetchAllRewards();
        expect(rewards, isEmpty);
      });

      test('returns only active rewards', () async {
        await repo.createReward(title: 'Active', targetPoints: 100);
        final result = await repo.createReward(
          title: 'To Delete',
          targetPoints: 200,
        );
        if (result is Success<Reward, AppError>) {
          await repo.deleteReward(result.value.id);
        }

        final rewards = await repo.fetchAllRewards();
        expect(rewards.length, 1);
        expect(rewards.first.title, 'Active');
      });
    });

    group('createReward', () {
      test('successfully creates a reward with required fields', () async {
        final result = await repo.createReward(
          title: 'Movie',
          targetPoints: 200,
        );

        expect(result, isA<Success<Reward, AppError>>());
        final reward = (result as Success<Reward, AppError>).value;
        expect(reward.title, 'Movie');
        expect(reward.targetPoints, 200);
        expect(reward.isActive, isTrue);
        expect(reward.category, isNull);
      });

      test('creates a reward with optional fields', () async {
        final result = await repo.createReward(
          title: 'Cake',
          targetPoints: 100,
          category: RewardCategory.food,
          memo: 'Delicious!',
        );

        final reward = (result as Success<Reward, AppError>).value;
        expect(reward.category, RewardCategory.food);
        expect(reward.memo, 'Delicious!');
      });
    });

    group('updateReward', () {
      test('successfully updates a reward', () async {
        final created = await repo.createReward(
          title: 'Old Title',
          targetPoints: 100,
        );
        final reward = (created as Success<Reward, AppError>).value;

        final result = await repo.updateReward(
          reward.copyWith(title: 'New Title', targetPoints: 200),
        );

        expect(result, isA<Success<Reward, AppError>>());
        final updated = (result as Success<Reward, AppError>).value;
        expect(updated.title, 'New Title');
        expect(updated.targetPoints, 200);
      });

      test('returns notFound error for non-existent reward', () async {
        final fakeReward = Reward(
          id: 999,
          title: 'Ghost',
          targetPoints: 100,
          createdAt: DateTime.now(),
        );

        final result = await repo.updateReward(fakeReward);
        expect(result, isA<Failure<Reward, AppError>>());
        expect(
          (result as Failure<Reward, AppError>).error,
          isA<NotFoundError>(),
        );
      });
    });

    group('deleteReward', () {
      test('logically deletes a reward', () async {
        final created = await repo.createReward(
          title: 'To Delete',
          targetPoints: 100,
        );
        final id = (created as Success<Reward, AppError>).value.id;

        final result = await repo.deleteReward(id);
        expect(result, isA<Success<void, AppError>>());

        final rewards = await repo.fetchAllRewards();
        expect(rewards.where((r) => r.id == id), isEmpty);
      });

      test('returns notFound error for non-existent reward', () async {
        final result = await repo.deleteReward(999);

        expect(result, isA<Failure<void, AppError>>());
        expect(
          (result as Failure<void, AppError>).error,
          isA<NotFoundError>(),
        );
      });
    });

    group('redeemReward', () {
      test('successfully redeems a reward with sufficient points', () async {
        final created = await repo.createReward(
          title: 'Nice Reward',
          targetPoints: 100,
        );
        final rewardId = (created as Success<Reward, AppError>).value.id;

        final result = await repo.redeemReward(rewardId, 150);

        expect(result, isA<Success<RewardRedemption, AppError>>());
        final redemption =
            (result as Success<RewardRedemption, AppError>).value;
        expect(redemption.rewardId, rewardId);
        expect(redemption.pointsSpent, 100);
      });

      test('returns insufficientPoints error when balance is too low',
          () async {
        final created = await repo.createReward(
          title: 'Expensive',
          targetPoints: 500,
        );
        final rewardId = (created as Success<Reward, AppError>).value.id;

        final result = await repo.redeemReward(rewardId, 100);

        expect(result, isA<Failure<RewardRedemption, AppError>>());
        expect(
          (result as Failure<RewardRedemption, AppError>).error,
          isA<InsufficientPointsError>(),
        );
      });

      test('returns notFound error for non-existent reward', () async {
        final result = await repo.redeemReward(999, 1000);

        expect(result, isA<Failure<RewardRedemption, AppError>>());
        expect(
          (result as Failure<RewardRedemption, AppError>).error,
          isA<NotFoundError>(),
        );
      });
    });
  });
}
