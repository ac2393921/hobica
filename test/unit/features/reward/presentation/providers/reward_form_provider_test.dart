import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/features/reward/presentation/providers/reward_form_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_form_state.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';

ProviderContainer _makeContainer(MockRewardRepository repo) {
  return ProviderContainer(
    overrides: [rewardRepositoryProvider.overrideWithValue(repo)],
  );
}

void main() {
  group('RewardFormState', () {
    test('default state has isSubmitting=false and no error', () {
      const state = RewardFormState();
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
      expect(state.savedReward, isNull);
    });

    test('copyWith updates fields correctly', () {
      const state = RewardFormState();
      final updated = state.copyWith(isSubmitting: true, error: 'エラー');
      expect(updated.isSubmitting, isTrue);
      expect(updated.error, 'エラー');
      expect(updated.savedReward, isNull);
    });
  });

  group('RewardFormProvider', () {
    test('submitCreate stores savedReward on success', () async {
      final repo = MockRewardRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container
          .read(rewardFormProvider.notifier)
          .submitCreate(title: 'ケーキ', targetPoints: 300);

      final state = container.read(rewardFormProvider);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
      expect(state.savedReward, isNotNull);
      expect(state.savedReward!.title, 'ケーキ');
      expect(state.savedReward!.targetPoints, 300);
    });

    test('submitUpdate modifies reward on success', () async {
      final repo = MockRewardRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      // 先に作成
      await container
          .read(rewardFormProvider.notifier)
          .submitCreate(title: '旧タイトル', targetPoints: 100);
      final created = container.read(rewardFormProvider).savedReward!;

      // 更新
      await container
          .read(rewardFormProvider.notifier)
          .submitUpdate(created.copyWith(title: '新タイトル', targetPoints: 200));

      final state = container.read(rewardFormProvider);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
      expect(state.savedReward!.title, '新タイトル');
      expect(state.savedReward!.targetPoints, 200);
    });

    test('submitUpdate with non-existent reward sets error', () async {
      final repo = MockRewardRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      // 存在しないIDのRewardを更新
      final fakeReward = (await repo.createReward(
        title: 'ghost',
        targetPoints: 1,
      )).when(success: (r) => r, failure: (_) => throw Exception());
      // リポジトリから削除
      await repo.deleteReward(fakeReward.id);

      await container
          .read(rewardFormProvider.notifier)
          .submitUpdate(fakeReward);

      final state = container.read(rewardFormProvider);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNotNull);
      expect(state.savedReward, isNull);
    });
  });
}
