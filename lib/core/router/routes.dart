/// ルートパス、ルート名、パラメータキーの定義
///
/// このファイルはgo_routerルーティング設定の定数を管理します。
/// 型安全なナビゲーションのため、すべての定数をクラスとして定義しています。

/// ルートパス定義
///
/// アプリ全体のルートパスを定数として管理。
/// 命名規則: ケバブケース（例: /habits, /rewards/new）
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String habits = '/habits';
  static const String rewards = '/rewards';
  static const String history = '/history';
  static const String settings = '/settings';
}

/// ルート名定義
///
/// 型安全なナビゲーションのためのルート名。
/// context.goNamed(AppRouteNames.habitList) のように使用。
/// 命名規則: パスカルケース（例: HabitList, RewardForm）
class AppRouteNames {
  AppRouteNames._();

  static const String home = 'Home';
  static const String habitList = 'HabitList';
  static const String rewardList = 'RewardList';
  static const String history = 'History';
  static const String settings = 'Settings';

  static const String habitDetail = 'HabitDetail';
  static const String habitEdit = 'HabitEdit';
  static const String habitForm = 'HabitForm';

  static const String rewardDetail = 'RewardDetail';
  static const String rewardEdit = 'RewardEdit';
  static const String rewardForm = 'RewardForm';

  static const String premium = 'Premium';
}

/// パスパラメータキー定義
///
/// URLパスパラメータのキー名を定数として管理。
/// state.pathParameters[AppRouteParams.id] のように使用。
class AppRouteParams {
  AppRouteParams._();

  /// ID パラメータ（習慣・ご褒美の識別子）
  static const String id = 'id';
}
