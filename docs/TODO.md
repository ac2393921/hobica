# TODO: hobica

作成日: 2026-02-16
生成元: planning-tasks
設計書: docs/DESIGN.md

## 概要

習慣を継続した結果として「ご褒美を解禁」し、継続を後押しするiOS/Androidアプリ。

**技術スタック**: Flutter, shadcn_flutter, Riverpod, go_router, Isar
**アーキテクチャ**: MVVM, feature-first
**開発期間**: 10-12週間（設計1週間、実装6-8週間、テスト2週間、リリース準備1週間）

## 実装タスク

### フェーズ0: プロジェクト初期化

- [ ] Flutterプロジェクト作成（`flutter create hobica`）
- [ ] FVMでFlutterバージョン固定（3.27.0）
- [ ] `.gitignore`の設定（build/, .dart_tool/, coverage/等）
- [ ] pubspec.yamlに依存パッケージ追加
  - shadcn_flutter
  - flutter_riverpod
  - go_router
  - isar
  - flutter_local_notifications
  - image_picker
  - in_app_purchase
  - google_mobile_ads
  - flutter_secure_storage（暗号化キー管理）
  - flutter_image_compress（画像圧縮）
  - logger（ロギング）
  - path_provider（ファイルパス取得）
  - freezed
  - json_serializable
  - mockito
  - build_runner（コード生成）
- [ ] [CHECK] `flutter pub get`実行と確認

### フェーズ1: プロジェクト構造のセットアップ

- [ ] [STRUCTURAL] ディレクトリ構造作成（feature-first）
  - lib/core/{router,theme,constants,utils,widgets}/
  - lib/features/{habit,reward,wallet,history,notification,settings,monetization,home}/
  - test/{unit,widget,integration}/
- [ ] [STRUCTURAL] コード生成設定（build.yaml）
- [ ] [CHECK] ディレクトリ構造確認

### フェーズ2: 基盤レイヤーの実装（Week 1）

#### 2.1 shadcn_flutterテーマ設定

- [ ] [RED] テーマ切り替えのテスト作成（ライト/ダーク）
- [ ] [GREEN] lib/core/theme/app_theme.dartの実装
- [ ] [GREEN] lib/core/theme/color_scheme.dartの実装
- [ ] [GREEN] lib/core/theme/typography.dartの実装
- [ ] [REFACTOR] テーマ設定の整理
- [ ] [CHECK] lint/format/build実行

#### 2.2 go_routerルーティング設定

- [ ] [RED] ルーティングのテスト作成（画面遷移）
- [ ] [GREEN] lib/core/router/routes.dartでルート定義
- [ ] [GREEN] lib/core/router/router.dartでGoRouter設定
- [ ] [REFACTOR] ルーティング設定の整理
- [ ] [CHECK] lint/format/build実行

#### 2.3 共通ウィジェット実装

- [ ] [RED] LoadingIndicatorのテスト作成
- [ ] [GREEN] lib/core/widgets/loading_indicator.dart実装
- [ ] [RED] ErrorViewのテスト作成
- [ ] [GREEN] lib/core/widgets/error_view.dart実装
- [ ] [RED] EmptyViewのテスト作成
- [ ] [GREEN] lib/core/widgets/empty_view.dart実装
- [ ] [REFACTOR] 共通ウィジェットの整理
- [ ] [CHECK] lint/format/build実行

#### 2.4 共通ユーティリティ実装

- [ ] [RED] DateUtilsのテスト作成（日付正規化）
- [ ] [GREEN] lib/core/utils/date_utils.dart実装
- [ ] [RED] Validatorsのテスト作成（バリデーション）
- [ ] [GREEN] lib/core/utils/validators.dart実装
- [ ] [REFACTOR] ユーティリティの整理
- [ ] [CHECK] lint/format/build実行

#### 2.5 エラー型とResult型の実装

- [ ] [RED] AppErrorのテスト作成
- [ ] [GREEN] lib/core/errors/app_error.dart実装（freezed使用）
- [ ] [RED] Result型のテスト作成
- [ ] [GREEN] lib/core/types/result.dart実装（freezed使用）
- [ ] [CHECK] コード生成（build_runner）実行
- [ ] [REFACTOR] エラーハンドリング整理
- [ ] [CHECK] lint/format/build実行

### フェーズ3: Isarデータベースのセットアップ（Week 1-2）

#### 3.1 Isarスキーマ定義

- [ ] [RED] Habitモデルのテスト作成
- [ ] [GREEN] lib/features/habit/domain/models/habit.dart実装
- [ ] [RED] HabitLogモデルのテスト作成
- [ ] [GREEN] lib/features/habit/domain/models/habit_log.dart実装
- [ ] [RED] Rewardモデルのテスト作成
- [ ] [GREEN] lib/features/reward/domain/models/reward.dart実装
- [ ] [RED] RewardRedemptionモデルのテスト作成
- [ ] [GREEN] lib/features/reward/domain/models/reward_redemption.dart実装
- [ ] [RED] Walletモデルのテスト作成
- [ ] [GREEN] lib/features/wallet/domain/models/wallet.dart実装
- [ ] [RED] AppSettingsモデルのテスト作成
- [ ] [GREEN] lib/features/settings/domain/models/app_settings.dart実装
- [ ] [RED] PremiumStatusモデルのテスト作成
- [ ] [GREEN] lib/features/monetization/domain/models/premium_status.dart実装
- [ ] [CHECK] コード生成（isar）実行
- [ ] [REFACTOR] モデル定義の整理
- [ ] [CHECK] lint/format/build実行

#### 3.2 Isar初期化とデータベースサービス

- [ ] [RED] Isar初期化のテスト作成
- [ ] [GREEN] lib/core/database/isar_service.dart実装
- [ ] [RED] 暗号化キー生成のテスト作成
- [ ] [GREEN] 暗号化キー管理の実装（flutter_secure_storage使用）
- [ ] [REFACTOR] データベース初期化の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ4: Habit機能の実装（Week 2-3）

#### 4.1 Habitリポジトリ（Domain Layer）

- [ ] [RED] HabitRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/habit/domain/repositories/habit_repository.dart実装

#### 4.2 HabitDataSource（Data Layer）

- [ ] [RED] HabitLocalDataSourceのテスト作成（CRUD）
- [ ] [GREEN] lib/features/habit/data/datasources/habit_local_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 4.3 HabitRepositoryImpl（Data Layer）

- [ ] [RED] HabitRepositoryImpl.fetchAllHabitsのテスト作成
- [ ] [GREEN] lib/features/habit/data/repositories/habit_repository_impl.dart（fetchAllHabits）実装
- [ ] [RED] HabitRepositoryImpl.createHabitのテスト作成
- [ ] [GREEN] createHabit実装
- [ ] [RED] HabitRepositoryImpl.updateHabitのテスト作成
- [ ] [GREEN] updateHabit実装
- [ ] [RED] HabitRepositoryImpl.deleteHabitのテスト作成
- [ ] [GREEN] deleteHabit実装
- [ ] [RED] HabitRepositoryImpl.completeHabitのテスト作成（連打防止含む）
- [ ] [GREEN] completeHabit実装
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 4.4 HabitProvider（Presentation Layer）

- [ ] [RED] HabitListProviderのテスト作成
- [ ] [GREEN] lib/features/habit/presentation/providers/habit_list_provider.dart実装
- [ ] [RED] HabitFormProviderのテスト作成
- [ ] [GREEN] lib/features/habit/presentation/providers/habit_form_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 4.5 Habitウィジェット（Presentation Layer）

- [ ] [RED] HabitCardウィジェットのテスト作成
- [ ] [GREEN] lib/features/habit/presentation/widgets/habit_card.dart実装（shadcn_flutter Card使用）
- [ ] [RED] HabitStreakIndicatorウィジェットのテスト作成
- [ ] [GREEN] lib/features/habit/presentation/widgets/habit_streak_indicator.dart実装
- [ ] [REFACTOR] ウィジェット実装の整理
- [ ] [CHECK] lint/format/build実行

#### 4.6 Habit画面（Presentation Layer）

- [ ] [RED] HabitListPageのテスト作成
- [ ] [GREEN] lib/features/habit/presentation/pages/habit_list_page.dart実装
- [ ] [RED] HabitDetailPageのテスト作成
- [ ] [GREEN] lib/features/habit/presentation/pages/habit_detail_page.dart実装
- [ ] [RED] HabitFormPageのテスト作成（作成/編集）
- [ ] [GREEN] lib/features/habit/presentation/pages/habit_form_page.dart実装
- [ ] [REFACTOR] 画面実装の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ5: Wallet機能の実装（Week 3）

#### 5.1 Walletリポジトリ（Domain Layer）

- [ ] [RED] WalletRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/wallet/domain/repositories/wallet_repository.dart実装

#### 5.2 WalletDataSource（Data Layer）

- [ ] [RED] WalletLocalDataSourceのテスト作成
- [ ] [GREEN] lib/features/wallet/data/datasources/wallet_local_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 5.3 WalletRepositoryImpl（Data Layer）

- [ ] [RED] WalletRepositoryImpl.getWalletのテスト作成
- [ ] [GREEN] lib/features/wallet/data/repositories/wallet_repository_impl.dart（getWallet）実装
- [ ] [RED] WalletRepositoryImpl.addPointsのテスト作成
- [ ] [GREEN] addPoints実装
- [ ] [RED] WalletRepositoryImpl.subtractPointsのテスト作成
- [ ] [GREEN] subtractPoints実装
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 5.4 WalletProvider（Presentation Layer）

- [ ] [RED] WalletProviderのテスト作成
- [ ] [GREEN] lib/features/wallet/presentation/providers/wallet_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 5.5 Walletウィジェット（Presentation Layer）

- [ ] [RED] WalletBalanceWidgetのテスト作成
- [ ] [GREEN] lib/features/wallet/presentation/widgets/wallet_balance_widget.dart実装（shadcn_flutter Badge使用）
- [ ] [REFACTOR] ウィジェット実装の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ6: Reward機能の実装（Week 3-4）

#### 6.1 Rewardリポジトリ（Domain Layer）

- [ ] [RED] RewardRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/reward/domain/repositories/reward_repository.dart実装

#### 6.2 RewardDataSource（Data Layer）

- [ ] [RED] RewardLocalDataSourceのテスト作成（CRUD）
- [ ] [GREEN] lib/features/reward/data/datasources/reward_local_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 6.3 RewardRepositoryImpl（Data Layer）

- [ ] [RED] RewardRepositoryImpl.fetchAllRewardsのテスト作成
- [ ] [GREEN] lib/features/reward/data/repositories/reward_repository_impl.dart（fetchAllRewards）実装
- [ ] [RED] RewardRepositoryImpl.createRewardのテスト作成
- [ ] [GREEN] createReward実装
- [ ] [RED] RewardRepositoryImpl.updateRewardのテスト作成
- [ ] [GREEN] updateReward実装
- [ ] [RED] RewardRepositoryImpl.deleteRewardのテスト作成
- [ ] [GREEN] deleteReward実装
- [ ] [RED] RewardRepositoryImpl.redeemRewardのテスト作成
- [ ] [GREEN] redeemReward実装（ポイント消費、RewardRedemption作成）
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 6.4 RewardProvider（Presentation Layer）

- [ ] [RED] RewardListProviderのテスト作成
- [ ] [GREEN] lib/features/reward/presentation/providers/reward_list_provider.dart実装
- [ ] [RED] RewardFormProviderのテスト作成
- [ ] [GREEN] lib/features/reward/presentation/providers/reward_form_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 6.5 Rewardウィジェット（Presentation Layer）

- [ ] [RED] RewardCardウィジェットのテスト作成
- [ ] [GREEN] lib/features/reward/presentation/widgets/reward_card.dart実装（shadcn_flutter Card, Progress使用）
- [ ] [RED] RewardProgressBarウィジェットのテスト作成
- [ ] [GREEN] lib/features/reward/presentation/widgets/reward_progress_bar.dart実装
- [ ] [REFACTOR] ウィジェット実装の整理
- [ ] [CHECK] lint/format/build実行

#### 6.6 Reward画面（Presentation Layer）

- [ ] [RED] RewardListPageのテスト作成
- [ ] [GREEN] lib/features/reward/presentation/pages/reward_list_page.dart実装
- [ ] [RED] RewardDetailPageのテスト作成
- [ ] [GREEN] lib/features/reward/presentation/pages/reward_detail_page.dart実装
- [ ] [RED] RewardFormPageのテスト作成（画像選択含む）
- [ ] [GREEN] lib/features/reward/presentation/pages/reward_form_page.dart実装
- [ ] [REFACTOR] 画面実装の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ7: 習慣達成フロー統合（Week 4）

- [ ] [RED] 習慣達成→ポイント加算→UI更新の統合テスト作成
- [ ] [GREEN] HabitRepositoryImpl.completeHabitでWalletRepositoryを呼び出す実装
- [ ] [RED] トランザクション処理のテスト作成（HabitLog + Wallet更新）
- [ ] [GREEN] トランザクション処理の実装
- [ ] [REFACTOR] フロー統合の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ8: ご褒美解禁・交換フロー統合（Week 4）

- [ ] [RED] ポイント到達→解禁判定のテスト作成
- [ ] [GREEN] 解禁判定ロジック実装（WalletProvider内）
- [ ] [RED] 交換処理のテスト作成（ポイント減算、RewardRedemption作成）
- [ ] [GREEN] 交換処理実装
- [ ] [REFACTOR] フロー統合の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ9: Home画面の実装（Week 5）

#### 9.1 HomeProvider（Presentation Layer）

- [ ] [RED] HomeProviderのテスト作成（今日の習慣、上位3つのご褒美取得）
- [ ] [GREEN] lib/features/home/presentation/providers/home_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 9.2 Homeウィジェット（Presentation Layer）

- [ ] [RED] TodayHabitsSectionのテスト作成
- [ ] [GREEN] lib/features/home/presentation/widgets/today_habits_section.dart実装
- [ ] [RED] TopRewardsSectionのテスト作成
- [ ] [GREEN] lib/features/home/presentation/widgets/top_rewards_section.dart実装
- [ ] [REFACTOR] ウィジェット実装の整理
- [ ] [CHECK] lint/format/build実行

#### 9.3 Home画面（Presentation Layer）

- [ ] [RED] HomePageのテスト作成
- [ ] [GREEN] lib/features/home/presentation/pages/home_page.dart実装
- [ ] [REFACTOR] 画面実装の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ10: History機能の実装（Week 5）

#### 10.1 Historyリポジトリ（Domain Layer）

- [ ] [RED] HistoryRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/history/domain/repositories/history_repository.dart実装

#### 10.2 HistoryDataSource（Data Layer）

- [ ] [RED] HistoryLocalDataSourceのテスト作成
- [ ] [GREEN] lib/features/history/data/datasources/history_local_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 10.3 HistoryRepositoryImpl（Data Layer）

- [ ] [RED] HistoryRepositoryImpl.fetchHabitLogsのテスト作成
- [ ] [GREEN] lib/features/history/data/repositories/history_repository_impl.dart（fetchHabitLogs）実装
- [ ] [RED] HistoryRepositoryImpl.fetchRedemptionsのテスト作成
- [ ] [GREEN] fetchRedemptions実装
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 10.4 HistoryProvider（Presentation Layer）

- [ ] [RED] HistoryProviderのテスト作成
- [ ] [GREEN] lib/features/history/presentation/providers/history_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 10.5 Historyウィジェット（Presentation Layer）

- [ ] [RED] PointHistoryListのテスト作成
- [ ] [GREEN] lib/features/history/presentation/widgets/point_history_list.dart実装
- [ ] [RED] RedemptionHistoryListのテスト作成
- [ ] [GREEN] lib/features/history/presentation/widgets/redemption_history_list.dart実装
- [ ] [REFACTOR] ウィジェット実装の整理
- [ ] [CHECK] lint/format/build実行

#### 10.6 History画面（Presentation Layer）

- [ ] [RED] HistoryPageのテスト作成（タブ切り替え含む）
- [ ] [GREEN] lib/features/history/presentation/pages/history_page.dart実装
- [ ] [REFACTOR] 画面実装の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ11: Notification機能の実装（Week 6）

#### 11.1 NotificationRepository（Domain Layer）

- [ ] [RED] NotificationRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/notification/domain/repositories/notification_repository.dart実装

#### 11.2 NotificationDataSource（Data Layer）

- [ ] [RED] NotificationLocalDataSourceのテスト作成
- [ ] [GREEN] lib/features/notification/data/datasources/notification_local_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 11.3 NotificationRepositoryImpl（Data Layer）

- [ ] [RED] NotificationRepositoryImpl.scheduleNotificationのテスト作成
- [ ] [GREEN] lib/features/notification/data/repositories/notification_repository_impl.dart（scheduleNotification）実装
- [ ] [RED] NotificationRepositoryImpl.cancelNotificationのテスト作成
- [ ] [GREEN] cancelNotification実装
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 11.4 NotificationProvider（Presentation Layer）

- [ ] [RED] NotificationProviderのテスト作成
- [ ] [GREEN] lib/features/notification/presentation/providers/notification_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 11.5 通知タップ時のディープリンク処理

- [ ] [RED] 通知タップ→習慣詳細画面遷移のテスト作成
- [ ] [GREEN] ディープリンク処理実装（go_router統合）
- [ ] [REFACTOR] ディープリンク処理の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ12: Settings機能の実装（Week 6）

#### 12.1 SettingsRepository（Domain Layer）

- [ ] [RED] SettingsRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/settings/domain/repositories/settings_repository.dart実装

#### 12.2 SettingsDataSource（Data Layer）

- [ ] [RED] SettingsLocalDataSourceのテスト作成
- [ ] [GREEN] lib/features/settings/data/datasources/settings_local_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 12.3 SettingsRepositoryImpl（Data Layer）

- [ ] [RED] SettingsRepositoryImpl.getSettingsのテスト作成
- [ ] [GREEN] lib/features/settings/data/repositories/settings_repository_impl.dart（getSettings）実装
- [ ] [RED] SettingsRepositoryImpl.updateThemeModeのテスト作成
- [ ] [GREEN] updateThemeMode実装
- [ ] [RED] SettingsRepositoryImpl.updateNotificationEnabledのテスト作成
- [ ] [GREEN] updateNotificationEnabled実装
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 12.4 SettingsProvider（Presentation Layer）

- [ ] [RED] SettingsProviderのテスト作成
- [ ] [GREEN] lib/features/settings/presentation/providers/settings_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 12.5 Settingsウィジェット（Presentation Layer）

- [ ] [RED] ThemeSwitcherのテスト作成
- [ ] [GREEN] lib/features/settings/presentation/widgets/theme_switcher.dart実装
- [ ] [REFACTOR] ウィジェット実装の整理
- [ ] [CHECK] lint/format/build実行

#### 12.6 Settings画面（Presentation Layer）

- [ ] [RED] SettingsPageのテスト作成
- [ ] [GREEN] lib/features/settings/presentation/pages/settings_page.dart実装
- [ ] [REFACTOR] 画面実装の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ13: Monetization機能の実装（Week 7）

#### 13.1 PurchaseRepository（Domain Layer）

- [ ] [RED] PurchaseRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/monetization/domain/repositories/purchase_repository.dart実装

#### 13.2 AdRepository（Domain Layer）

- [ ] [RED] AdRepositoryインターフェースのテスト作成
- [ ] [GREEN] lib/features/monetization/domain/repositories/ad_repository.dart実装

#### 13.3 PurchaseDataSource（Data Layer）

- [ ] [RED] PurchaseDataSourceのテスト作成
- [ ] [GREEN] lib/features/monetization/data/datasources/purchase_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 13.4 AdDataSource（Data Layer）

- [ ] [RED] AdDataSourceのテスト作成
- [ ] [GREEN] lib/features/monetization/data/datasources/ad_datasource.dart実装
- [ ] [REFACTOR] DataSource実装の整理
- [ ] [CHECK] lint/format/build実行

#### 13.5 PurchaseRepositoryImpl（Data Layer）

- [ ] [RED] PurchaseRepositoryImpl.purchasePremiumのテスト作成
- [ ] [GREEN] lib/features/monetization/data/repositories/purchase_repository_impl.dart（purchasePremium）実装
- [ ] [RED] PurchaseRepositoryImpl.restorePurchasesのテスト作成
- [ ] [GREEN] restorePurchases実装
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 13.6 AdRepositoryImpl（Data Layer）

- [ ] [RED] AdRepositoryImpl.loadBannerAdのテスト作成
- [ ] [GREEN] lib/features/monetization/data/repositories/ad_repository_impl.dart（loadBannerAd）実装
- [ ] [RED] AdRepositoryImpl.showInterstitialAdのテスト作成
- [ ] [GREEN] showInterstitialAd実装
- [ ] [REFACTOR] Repository実装の整理
- [ ] [CHECK] lint/format/build実行

#### 13.7 MonetizationProvider（Presentation Layer）

- [ ] [RED] PurchaseProviderのテスト作成
- [ ] [GREEN] lib/features/monetization/presentation/providers/purchase_provider.dart実装
- [ ] [RED] AdProviderのテスト作成
- [ ] [GREEN] lib/features/monetization/presentation/providers/ad_provider.dart実装
- [ ] [REFACTOR] Provider実装の整理
- [ ] [CHECK] lint/format/build実行

#### 13.8 Monetizationウィジェット（Presentation Layer）

- [ ] [RED] AdBannerWidgetのテスト作成
- [ ] [GREEN] lib/features/monetization/presentation/widgets/ad_banner_widget.dart実装
- [ ] [RED] PremiumFeaturesListのテスト作成
- [ ] [GREEN] lib/features/monetization/presentation/widgets/premium_features_list.dart実装
- [ ] [REFACTOR] ウィジェット実装の整理
- [ ] [CHECK] lint/format/build実行

#### 13.9 Premium画面（Presentation Layer）

- [ ] [RED] PremiumPageのテスト作成
- [ ] [GREEN] lib/features/monetization/presentation/pages/premium_page.dart実装
- [ ] [REFACTOR] 画面実装の整理
- [ ] [CHECK] lint/format/build実行

### フェーズ14: アプリ統合（Week 7-8）

#### 14.1 メインアプリの実装

- [ ] [RED] main.dartのテスト作成（Isar初期化、Provider設定）
- [ ] [GREEN] lib/main.dart実装
- [ ] [RED] app.dartのテスト作成（MaterialApp、shadcn_flutterテーマ適用）
- [ ] [GREEN] lib/app.dart実装
- [ ] [REFACTOR] アプリエントリーポイントの整理
- [ ] [CHECK] lint/format/build実行

#### 14.2 ボトムナビゲーションの実装

- [ ] [RED] ボトムナビゲーション（Tabs）のテスト作成
- [ ] [GREEN] shadcn_flutter Tabsを使用したナビゲーション実装
- [ ] [REFACTOR] ナビゲーションの整理
- [ ] [CHECK] lint/format/build実行

#### 14.3 スプラッシュ画面の実装

- [ ] [RED] スプラッシュ画面のテスト作成
- [ ] [GREEN] flutter_native_splashでスプラッシュ画面設定
- [ ] [CHECK] lint/format/build実行

### フェーズ15: 統合テスト（Week 8）

#### 15.1 主要フロー統合テスト

- [ ] [RED] 習慣作成→達成→ポイント獲得フローの統合テスト作成
- [ ] [GREEN] フロー実装確認と修正
- [ ] [RED] ご褒美作成→解禁→交換フローの統合テスト作成
- [ ] [GREEN] フロー実装確認と修正
- [ ] [RED] 通知設定→配信→タップ→画面遷移フローの統合テスト作成
- [ ] [GREEN] フロー実装確認と修正
- [ ] [RED] テーマ切り替えフローの統合テスト作成
- [ ] [GREEN] フロー実装確認と修正
- [ ] [RED] プレミアム課金フローの統合テスト作成
- [ ] [GREEN] フロー実装確認と修正
- [ ] [CHECK] 全統合テスト実行

#### 15.2 エッジケーステスト

- [ ] [RED] 習慣達成連打防止のテスト作成
- [ ] [GREEN] 連打防止実装確認
- [ ] [RED] ポイント不足時のご褒美交換エラーのテスト作成
- [ ] [GREEN] エラーハンドリング確認
- [ ] [RED] 無料枠上限（習慣3個、ご褒美3個）のテスト作成
- [ ] [GREEN] 上限チェック実装
- [ ] [CHECK] エッジケーステスト実行

### フェーズ16: 品質保証（Week 8-9）

- [ ] [STRUCTURAL] 全コードのフォーマット実行（`flutter format .`）
- [ ] [CHECK] 全テスト実行（`flutter test --coverage`）
- [ ] [CHECK] カバレッジ確認（目標: 80%以上）
- [ ] [CHECK] Lint実行（`flutter analyze`）
- [ ] [CHECK] ビルド確認（Android: `flutter build apk`, iOS: `flutter build ios`）
- [ ] [REFACTOR] パフォーマンス最適化（画像圧縮、Isarインデックス確認）
- [ ] [CHECK] 動作確認（実機テスト: iOS/Android）

### フェーズ17: リリース準備（Week 9-10）

- [ ] Android: アプリアイコン設定
- [ ] iOS: アプリアイコン設定
- [ ] Android: app/build.gradleのバージョン設定
- [ ] iOS: Info.plistの設定
- [ ] プライバシーポリシー作成
- [ ] 利用規約作成
- [ ] App Store Connect: アプリ情報登録
- [ ] Google Play Console: アプリ情報登録
- [ ] スクリーンショット作成（iOS/Android各5枚）
- [ ] App Store / Google Play: リリース申請

## 実装ノート

### MUSTルール遵守事項

- **TDD**: RED → GREEN → REFACTOR → CHECK サイクルを厳守
- **CHECK**: 各フェーズ完了時に lint/format/build を実行
- **Tidy First**: 構造変更（[STRUCTURAL]）と動作変更（[BEHAVIORAL]）を分離
- **コミット**: 各タスク完了時にコミット。[BEHAVIORAL] または [STRUCTURAL] プレフィックス必須

### テスト戦略

- **ユニットテスト**: Repository, DataSource, Provider, Model（60%）
- **ウィジェットテスト**: Widget, Page（30%）
- **統合テスト**: 主要フロー（10%）
- **カバレッジ目標**: 全体 80%以上、ビジネスロジック 90%以上

### 参照ドキュメント

- 設計書: `docs/DESIGN.md`
- テスト駆動開発: TDD サイクル（RED → GREEN → REFACTOR → CHECK）
- Tidy First: 構造変更と動作変更の分離

---

**Document Version**: 1.0
**Last Updated**: 2026-02-16
**Status**: Ready（実装準備完了）
