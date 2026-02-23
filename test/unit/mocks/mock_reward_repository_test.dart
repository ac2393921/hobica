import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';

void main() {
  late MockRewardRepository repository;

  setUp(() {
    repository = MockRewardRepository();
  });

  group('MockRewardRepository', () {
    group('fetchAllRewards', () {
      test('returns empty list initially', () async {
        final result = await repository.fetchAllRewards();
        expect(result, isEmpty);
      });

      test('returns all created rewards', () async {
        await repository.createReward(title: 'Coffee', targetPoints: 100);
        await repository.createReward(title: 'Movie', targetPoints: 300);

        final rewards = await repository.fetchAllRewards();
        expect(rewards.length, 2);
      });
    });

    group('fetchRewardById', () {
      test('returns null for non-existent id', () async {
        final result = await repository.fetchRewardById(999);
        expect(result, isNull);
      });

      test('returns reward for existing id', () async {
        final created = await repository.createReward(
          title: 'Coffee',
          targetPoints: 100,
        );
        final id = (created as Success<Reward, AppError>).value.id;

        final result = await repository.fetchRewardById(id);
        expect(result, isNotNull);
        expect(result!.title, 'Coffee');
      });
    });

    group('createReward', () {
      test('returns success with auto-incremented id', () async {
        final result1 = await repository.createReward(
          title: 'Reward A',
          targetPoints: 100,
        );
        final result2 = await repository.createReward(
          title: 'Reward B',
          targetPoints: 200,
        );

        expect(result1, isA<Success<Reward, AppError>>());
        expect(result2, isA<Success<Reward, AppError>>());

        final id1 = (result1 as Success<Reward, AppError>).value.id;
        final id2 = (result2 as Success<Reward, AppError>).value.id;
        expect(id2, id1 + 1);
      });

      test('stores reward with optional fields', () async {
        final result = await repository.createReward(
          title: 'Coffee',
          targetPoints: 100,
          category: RewardCategory.food,
          memo: 'Treat yourself',
        );

        final reward = (result as Success<Reward, AppError>).value;
        expect(reward.title, 'Coffee');
        expect(reward.targetPoints, 100);
        expect(reward.category, RewardCategory.food);
        expect(reward.memo, 'Treat yourself');
        expect(reward.imageUri, isNull);
        expect(reward.isActive, isTrue);
      });
    });

    group('updateReward', () {
      test('returns failure for non-existent reward', () async {
        final nonExistent = Reward(
          id: 999,
          title: 'Ghost',
          targetPoints: 100,
          createdAt: DateTime.now(),
        );

        final result = await repository.updateReward(nonExistent);
        expect(result, isA<Failure<Reward, AppError>>());
        expect(
          (result as Failure<Reward, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('updates and returns modified reward', () async {
        final created = await repository.createReward(
          title: 'Old Title',
          targetPoints: 100,
        );
        final reward = (created as Success<Reward, AppError>).value;

        final updated = reward.copyWith(title: 'New Title', targetPoints: 200);
        final result = await repository.updateReward(updated);

        expect(result, isA<Success<Reward, AppError>>());
        final returned = (result as Success<Reward, AppError>).value;
        expect(returned.title, 'New Title');
        expect(returned.targetPoints, 200);

        final fetched = await repository.fetchRewardById(reward.id);
        expect(fetched!.title, 'New Title');
      });
    });

    group('deleteReward', () {
      test('returns failure for non-existent id', () async {
        final result = await repository.deleteReward(999);
        expect(result, isA<Failure<void, AppError>>());
        expect(
          (result as Failure<void, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('removes reward on success', () async {
        final created = await repository.createReward(
          title: 'To Delete',
          targetPoints: 50,
        );
        final id = (created as Success<Reward, AppError>).value.id;

        final deleteResult = await repository.deleteReward(id);
        expect(deleteResult, isA<Success<void, AppError>>());

        final fetched = await repository.fetchRewardById(id);
        expect(fetched, isNull);
      });
    });

    group('redeemReward', () {
      test('returns failure for non-existent rewardId', () async {
        final result = await repository.redeemReward(999, 500);
        expect(result, isA<Failure<RewardRedemption, AppError>>());
        expect(
          (result as Failure<RewardRedemption, AppError>).error,
          isA<NotFoundError>(),
        );
      });

      test('returns insufficientPoints when currentPoints < targetPoints',
          () async {
        final created = await repository.createReward(
          title: 'Coffee',
          targetPoints: 100,
        );
        final rewardId = (created as Success<Reward, AppError>).value.id;

        final result = await repository.redeemReward(rewardId, 50);
        expect(result, isA<Failure<RewardRedemption, AppError>>());
        expect(
          (result as Failure<RewardRedemption, AppError>).error,
          isA<InsufficientPointsError>(),
        );
      });

      test('succeeds when currentPoints == targetPoints', () async {
        final created = await repository.createReward(
          title: 'Coffee',
          targetPoints: 100,
        );
        final rewardId = (created as Success<Reward, AppError>).value.id;

        final result = await repository.redeemReward(rewardId, 100);
        expect(result, isA<Success<RewardRedemption, AppError>>());

        final redemption = (result as Success<RewardRedemption, AppError>).value;
        expect(redemption.rewardId, rewardId);
        expect(redemption.pointsSpent, 100);
      });

      test('succeeds when currentPoints > targetPoints', () async {
        final created = await repository.createReward(
          title: 'Coffee',
          targetPoints: 100,
        );
        final rewardId = (created as Success<Reward, AppError>).value.id;

        final result = await repository.redeemReward(rewardId, 200);
        expect(result, isA<Success<RewardRedemption, AppError>>());
      });

      test('stores redemption accessible via redemptions getter', () async {
        final created = await repository.createReward(
          title: 'Coffee',
          targetPoints: 100,
        );
        final rewardId = (created as Success<Reward, AppError>).value.id;

        await repository.redeemReward(rewardId, 150);
        expect(repository.redemptions.length, 1);
        expect(repository.redemptions.first.rewardId, rewardId);
      });
    });
  });
}
