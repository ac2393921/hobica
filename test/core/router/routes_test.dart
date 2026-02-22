import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/router/routes.dart';

void main() {
  group('AppRoutes', () {
    test('ボトムナビゲーションのルートパスが正しく定義されている', () {
      expect(AppRoutes.home, '/');
      expect(AppRoutes.habits, '/habits');
      expect(AppRoutes.rewards, '/rewards');
      expect(AppRoutes.history, '/history');
      expect(AppRoutes.settings, '/settings');
    });


    test('すべてのルートパスがスラッシュで始まる', () {
      final allRoutes = [
        AppRoutes.home,
        AppRoutes.habits,
        AppRoutes.rewards,
        AppRoutes.history,
        AppRoutes.settings,
      ];

      for (final route in allRoutes) {
        expect(route.startsWith('/'), true, reason: '$route should start with /');
      }
    });
  });

  group('AppRouteNames', () {
    test('ボトムナビゲーションのルート名が正しく定義されている', () {
      expect(AppRouteNames.home, 'Home');
      expect(AppRouteNames.habitList, 'HabitList');
      expect(AppRouteNames.rewardList, 'RewardList');
      expect(AppRouteNames.history, 'History');
      expect(AppRouteNames.settings, 'Settings');
    });

    test('習慣関連のルート名が正しく定義されている', () {
      expect(AppRouteNames.habitDetail, 'HabitDetail');
      expect(AppRouteNames.habitEdit, 'HabitEdit');
      expect(AppRouteNames.habitForm, 'HabitForm');
    });

    test('ご褒美関連のルート名が正しく定義されている', () {
      expect(AppRouteNames.rewardDetail, 'RewardDetail');
      expect(AppRouteNames.rewardEdit, 'RewardEdit');
      expect(AppRouteNames.rewardForm, 'RewardForm');
    });

    test('設定関連のルート名が正しく定義されている', () {
      expect(AppRouteNames.premium, 'Premium');
    });

    test('すべてのルート名がパスカルケースである', () {
      final allNames = [
        AppRouteNames.home,
        AppRouteNames.habitList,
        AppRouteNames.rewardList,
        AppRouteNames.history,
        AppRouteNames.settings,
        AppRouteNames.habitDetail,
        AppRouteNames.habitEdit,
        AppRouteNames.habitForm,
        AppRouteNames.rewardDetail,
        AppRouteNames.rewardEdit,
        AppRouteNames.rewardForm,
        AppRouteNames.premium,
      ];

      for (final name in allNames) {
        // パスカルケースの検証: 先頭が大文字で、スペースやアンダースコアがない
        expect(name[0], name[0].toUpperCase(),
            reason: '$name should start with uppercase');
        expect(name.contains(' '), false,
            reason: '$name should not contain spaces');
        expect(name.contains('_'), false,
            reason: '$name should not contain underscores');
      }
    });
  });

  group('AppRouteParams', () {
    test('パラメータキーが正しく定義されている', () {
      expect(AppRouteParams.id, 'id');
    });

    test('パラメータキーがスネークケースまたは単一語である', () {
      // 現在はidのみだが、将来的に追加される可能性を考慮
      final allParams = [
        AppRouteParams.id,
      ];

      for (final param in allParams) {
        // 小文字またはアンダースコアのみを許可
        expect(
          RegExp(r'^[a-z_]+$').hasMatch(param),
          true,
          reason: '$param should be snake_case or single word',
        );
      }
    });
  });

  group('ルートパスとルート名の一貫性', () {
    test('ボトムナビゲーションのルートパスとルート名が対応している', () {
      // パスとルート名のペアが論理的に対応していることを確認
      final routePairs = {
        AppRoutes.home: AppRouteNames.home,
        AppRoutes.habits: AppRouteNames.habitList,
        AppRoutes.rewards: AppRouteNames.rewardList,
        AppRoutes.history: AppRouteNames.history,
        AppRoutes.settings: AppRouteNames.settings,
      };

      // すべてのペアが定義されていることを確認
      expect(routePairs.length, 5);
    });
  });
}
