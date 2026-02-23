import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/mocks/reward_repository_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_form_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:hobica/mocks/mock_reward_repository.dart';

void main() {
  group('RewardFormProvider', () {
    late ProviderContainer container;

    ProviderContainer makeContainer() {
      final c = ProviderContainer(
        overrides: [
          rewardRepositoryProvider.overrideWith((_) => MockRewardRepository()),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    setUp(() {
      container = makeContainer();
    });

    group('build() - 新規作成モード（initial = null）', () {
      test('初期状態は空フォーム', () {
        final state = container.read(rewardFormProvider());
        expect(state.title, '');
        expect(state.imageUri, isNull);
        expect(state.targetPointsText, '');
        expect(state.category, isNull);
        expect(state.memo, isNull);
        expect(state.isSubmitting, isFalse);
        expect(state.submitError, isNull);
      });
    });

    group('build() - 編集モード（initial = Reward）', () {
      test('既存 Reward の値が注入される', () {
        final reward = Reward(
          id: 1,
          title: 'コーヒー',
          imageUri: 'https://example.com/coffee.png',
          targetPoints: 100,
          category: RewardCategory.food,
          memo: 'おいしい',
          createdAt: DateTime(2024, 1, 1),
        );

        final state = container.read(rewardFormProvider(initial: reward));
        expect(state.title, 'コーヒー');
        expect(state.imageUri, 'https://example.com/coffee.png');
        expect(state.targetPointsText, '100');
        expect(state.category, RewardCategory.food);
        expect(state.memo, 'おいしい');
      });
    });

    group('update メソッド', () {
      test('updateTitle で title が更新される', () {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTitle('新しいタイトル');
        expect(container.read(rewardFormProvider()).title, '新しいタイトル');
      });

      test('updateImageUri で imageUri が更新される', () {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateImageUri('https://example.com/image.png');
        expect(
          container.read(rewardFormProvider()).imageUri,
          'https://example.com/image.png',
        );
      });

      test('updateTargetPoints で targetPointsText が更新される', () {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTargetPoints('200');
        expect(container.read(rewardFormProvider()).targetPointsText, '200');
      });

      test('updateCategory で category が更新される', () {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateCategory(RewardCategory.food);
        expect(container.read(rewardFormProvider()).category, RewardCategory.food);
      });

      test('updateMemo で memo が更新される', () {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateMemo('メモです');
        expect(container.read(rewardFormProvider()).memo, 'メモです');
      });
    });

    group('save() - バリデーション失敗', () {
      test('title が空のとき Failure(AppError.validation) を返す', () async {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTargetPoints('100');

        final result = await notifier.save();

        expect(result, isA<Failure<Reward, AppError>>());
        final error = (result as Failure<Reward, AppError>).error;
        expect(error, isA<ValidationError>());
        expect(container.read(rewardFormProvider()).submitError, isA<ValidationError>());
      });

      test('targetPoints が不正のとき Failure(AppError.validation) を返す', () async {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTitle('コーヒー');
        notifier.updateTargetPoints('abc');

        final result = await notifier.save();

        expect(result, isA<Failure<Reward, AppError>>());
        final error = (result as Failure<Reward, AppError>).error;
        expect(error, isA<ValidationError>());
      });

      test('targetPoints が0以下のとき Failure を返す', () async {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTitle('コーヒー');
        notifier.updateTargetPoints('0');

        final result = await notifier.save();

        expect(result, isA<Failure<Reward, AppError>>());
      });
    });

    group('save() - 成功', () {
      test('有効な入力で Success(Reward) を返す', () async {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTitle('コーヒー');
        notifier.updateTargetPoints('100');

        final result = await notifier.save();

        expect(result, isA<Success<Reward, AppError>>());
        final reward = (result as Success<Reward, AppError>).value;
        expect(reward.title, 'コーヒー');
        expect(reward.targetPoints, 100);
      });

      test('save() 成功後に isSubmitting が false に戻る', () async {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTitle('コーヒー');
        notifier.updateTargetPoints('100');

        await notifier.save();

        expect(container.read(rewardFormProvider()).isSubmitting, isFalse);
      });

      test('save() 成功後に rewardListProvider が invalidate される', () async {
        // 最初にリストをキャッシュ
        final initialList = await container.read(rewardListProvider.future);
        expect(initialList, hasLength(2));

        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTitle('ケーキ');
        notifier.updateTargetPoints('200');
        await notifier.save();

        // invalidate 後に再取得すると3件になっている
        final updatedList = await container.read(rewardListProvider.future);
        expect(updatedList, hasLength(3));
      });

      test('編集モードで save() すると updateReward が呼ばれる', () async {
        final existing = Reward(
          id: 1,
          title: 'コーヒー',
          targetPoints: 100,
          createdAt: DateTime(2024, 1, 1),
        );

        final editContainer = ProviderContainer(
          overrides: [
            rewardRepositoryProvider.overrideWith((_) => MockRewardRepository()),
          ],
        );
        addTearDown(editContainer.dispose);

        // 最初にリストをキャッシュ（初期データ2件）
        await editContainer.read(rewardListProvider.future);

        final notifier = editContainer.read(
          rewardFormProvider(initial: existing).notifier,
        );
        notifier.updateTitle('コーヒー（更新）');

        final result = await notifier.save();

        expect(result, isA<Success<Reward, AppError>>());
        final updated = (result as Success<Reward, AppError>).value;
        expect(updated.title, 'コーヒー（更新）');
        expect(updated.id, 1);
      });
    });

    group('isSubmitting フラグ', () {
      test('save() 完了後に isSubmitting が false になる', () async {
        final notifier = container.read(rewardFormProvider().notifier);
        notifier.updateTitle('コーヒー');
        notifier.updateTargetPoints('100');

        await notifier.save();

        // save() 完了後は false に戻っている
        expect(container.read(rewardFormProvider()).isSubmitting, isFalse);
      });
    });
  });
}
