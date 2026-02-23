import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_redemption.dart';
import 'package:hobica/features/reward/domain/repositories/reward_repository.dart';
import 'package:hobica/mocks/reward_repository_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';

void main() {
  group('RewardListProvider', () {
    late ProviderContainer container;
    late MockRewardRepository mockRepository;

    setUp(() {
      mockRepository = MockRewardRepository();
      container = ProviderContainer(
        overrides: [
          rewardRepositoryProvider.overrideWith((_) => mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は AsyncLoading', () {
      final state = container.read(rewardListProvider);
      expect(state, isA<AsyncLoading<List<Reward>>>());
    });

    test('fetchAllRewards が返すリストを正しく公開する', () async {
      final result = await container.read(rewardListProvider.future);
      // MockRewardRepository の初期データは2件
      expect(result, hasLength(2));
      expect(result[0].title, 'コーヒー');
      expect(result[1].title, 'マッサージ');
    });

    test('refresh() でデータが再取得される', () async {
      // 初回取得
      await container.read(rewardListProvider.future);
      expect(
        container.read(rewardListProvider).value,
        hasLength(2),
      );

      // リポジトリにデータを追加してからリフレッシュ
      await mockRepository.createReward(
        title: 'ケーキ',
        targetPoints: 200,
      );

      final notifier = container.read(rewardListProvider.notifier);
      await notifier.refresh();

      expect(
        container.read(rewardListProvider).value,
        hasLength(3),
      );
    });

    test('RewardRepository を override して任意の実装を注入できる', () async {
      final customMock = _AlwaysEmptyRewardRepository();
      final customContainer = ProviderContainer(
        overrides: [
          rewardRepositoryProvider.overrideWith((_) => customMock),
        ],
      );
      addTearDown(customContainer.dispose);

      final result = await customContainer.read(rewardListProvider.future);
      expect(result, isEmpty);
    });
  });

  group('MockRewardRepository.redeemReward', () {
    late MockRewardRepository repo;

    setUp(() {
      repo = MockRewardRepository();
    });

    test('存在するご褒美を使用すると RewardRedemption が返る', () async {
      final result = await repo.redeemReward(1, 100);

      expect(result, isA<Success<RewardRedemption, AppError>>());
      final redemption = (result as Success<RewardRedemption, AppError>).value;
      expect(redemption.rewardId, 1);
      expect(redemption.pointsSpent, 100);
    });

    test('id は _nextId から自動インクリメントされる', () async {
      final first = await repo.redeemReward(1, 100);
      final second = await repo.redeemReward(2, 500);

      final firstId = (first as Success<RewardRedemption, AppError>).value.id;
      final secondId = (second as Success<RewardRedemption, AppError>).value.id;
      expect(secondId, firstId + 1);
    });

    test('存在しないご褒美を使用すると notFound エラーが返る', () async {
      final result = await repo.redeemReward(999, 100);

      expect(result, isA<Failure<RewardRedemption, AppError>>());
    });
  });
}

/// テスト用：常に空リストを返すリポジトリ
class _AlwaysEmptyRewardRepository implements RewardRepository {
  @override
  Future<List<Reward>> fetchAllRewards() async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}
