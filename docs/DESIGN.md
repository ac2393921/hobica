# hobica 設計ドキュメント

生成日: 2026-02-16
ジェネレーター: analyzing-requirements

## システム概要

### 目的
習慣を継続した結果として「ご褒美を解禁」し、継続を後押しするiOS/Androidアプリ。罰なし、でも「もう少しで解禁」という心理的な動機付けで習慣化を支援する。

### 解決する問題
- 習慣継続のモチベーション維持が困難
- 衝動買いの抑制と計画的な購入の促進
- 目標達成の可視化と達成感の提供

### ビジネス価値
- **継続率**: 7日継続率、30日継続率の向上
- **ご褒美解禁数**: ユーザーのエンゲージメント指標
- **課金率**: プレミアム機能への転換率

### 対象ユーザー
- 習慣化したいが続かない人
- 衝動買いを抑制したい人
- ゲーミフィケーションで楽しく目標達成したい人

## 用語定義

| 用語 | 英語表記 | 説明 |
|------|----------|------|
| 習慣 | Habit | 毎日/週○回などの行動。達成でポイント付与 |
| ご褒美 | Reward/Wish | 欲しいもの・体験。必要ポイントを満たすと「解禁」 |
| ポイント | Point | アプリ内通貨。習慣達成で増える |
| 解禁 | Unlock | ポイントが条件を満たした状態。購入/実行の「許可」 |
| 交換 | Redemption | ポイントを消費してご褒美を獲得 |
| 連続達成 | Streak | 習慣を連続で達成した日数 |

## 機能要件

### 必須機能（MUST have）

#### 1. アカウント管理
- **MVP範囲**: ログインなし（端末内保存のみ）
- **将来拡張**: アカウント登録、データ同期

#### 2. 習慣管理
- **習慣作成**
  - タイトル入力（必須）
  - 頻度設定: 毎日（MVP）/ 週n回（将来拡張）
  - 付与ポイント設定（例: 30, 50, 100）
  - リマインド時刻設定（任意）
- **習慣一覧表示**
  - 今日の習慣カード
  - 達成ボタン
  - 連続達成（streak）表示（任意）
- **習慣達成**
  - ワンタップで達成登録
  - ポイント即座に付与
  - 達成から10分以内は取消可能
- **習慣編集・削除**

#### 3. ご褒美（欲しい物）管理
- **ご褒美作成**
  - タイトル入力（必須）
  - 画像登録（カメラ/アルバムから選択）
  - 必要ポイント設定（例: 2000）
  - カテゴリ選択（物/体験/食/美容など、任意）
  - メモ（任意）
- **ご褒美一覧表示**
  - 画像サムネイル
  - 進捗バー（現在ポイント / 必要ポイント）
  - 「あと◯pt」表示
- **ご褒美詳細表示**
  - 画像拡大表示
  - 進捗詳細
  - 解禁/交換ボタン
- **ご褒美編集・削除**

#### 4. ポイント管理
- **ポイント付与**
  - 習慣達成時に自動加算
  - 付与履歴の記録
- **ポイント残高表示**
  - アプリ上部に常時表示
  - リアルタイム更新
- **ポイント消費**
  - ご褒美交換時に減算
  - 消費履歴の記録

#### 5. 解禁フロー
- **解禁条件判定**
  - ポイントが必要量に達したら自動解禁
- **解禁通知**
  - アプリ内通知
  - プッシュ通知（リマインド設定時）
- **交換処理**
  - 「交換する」ボタンでポイント消費
  - 交換履歴に記録
  - ポイント残高更新

#### 6. リマインド通知（MVP追加機能）
- **通知設定**
  - 習慣ごとに時刻設定
  - ON/OFF切り替え
- **通知配信**
  - ローカル通知（flutter_local_notifications）
  - 通知タップでアプリ起動→該当習慣画面へ

#### 7. 履歴画面（MVP追加機能）
- **ポイント獲得履歴**
  - いつ、何の習慣で、何pt増えたか
  - 日付でグループ化
- **ご褒美交換履歴**
  - いつ、何を交換したか
  - 消費ポイント表示

#### 8. テーマ切り替え（MVP追加機能）
- **ライト/ダークモード**
  - システム設定に追従
  - アプリ内で手動切り替え可能

### オプション機能（NICE to have）

#### 将来拡張機能（優先順位順）
1. **ウィジェット**
   - ホーム画面で今日の習慣を表示
   - ワンタップで達成登録
2. **統計・分析**
   - ヒートマップ（連続記録）
   - 週/月レポート
   - 達成率グラフ
3. **ご褒美テンプレート**
   - カテゴリ別のおすすめご褒美
   - 映画/カフェ/旅行などの提案
4. **衝動買い防止機能**
   - 7日待機リスト
   - 「今買う前に登録」機能
5. **ソーシャル機能**
   - 友達応援（SNS疲れしない範囲）
   - 達成シェア（任意）

## 非機能要件

### パフォーマンス要件
- **起動時間**: 2秒以内（コールドスタート）
- **画面遷移**: 300ms以内（体感でスムーズ）
- **データ同期**: 500ms以内（ローカルDB）
- **通知配信**: 設定時刻の±1分以内

### セキュリティ要件
- **データ保護**
  - SQLCipherによるSQLiteファイルレベルの暗号化（将来対応）
  - 端末ロック時のデータ保護
- **不正対策**
  - 習慣達成の連打防止（1日1回制限）
  - 端末時刻変更検知（将来: サーバ時刻基準）
- **プライバシー**
  - 個人情報は端末内のみ保存（MVP）
  - データエクスポート機能（将来）

### 可用性・信頼性
- **オフライン動作**
  - 全機能オフラインで動作（MVP）
  - 将来: クラウド同期時のオフライン対応
- **データバックアップ**
  - SQLiteファイルのバックアップ（iCloud/Googleバックアップ経由）
  - エクスポート/インポート機能（将来）
- **エラーハンドリング**
  - ユーザーフレンドリーなエラーメッセージ
  - クラッシュレポート（将来: Firebase Crashlytics）

### ユーザビリティ
- **多言語対応**: MVP: 日本語のみ、将来: 英語対応
- **アクセシビリティ**:
  - スクリーンリーダー対応
  - 最小タップ領域: 44x44pt
  - コントラスト比: WCAG 2.1 AA準拠
- **プラットフォーム対応**:
  - iOS: 14.0以上
  - Android: API Level 21（Android 5.0）以上

## アーキテクチャ設計

### 技術スタック

#### フロントエンド（Flutter）
| カテゴリ | ライブラリ | バージョン | 用途 |
|----------|-----------|-----------|------|
| フレームワーク | Flutter | 3.27.x | UI構築 |
| UIコンポーネント | shadcn_flutter | latest | モダンなshadcn/uiスタイルのコンポーネント（84+） |
| 状態管理 | flutter_riverpod | 2.x | アプリ全体の状態管理 |
| ルーティング | go_router | 14.x | 宣言的ルーティング、Deep Link |
| データベース | drift | 2.x | type-safe SQLiteローカルデータベース |
| 通知 | flutter_local_notifications | 18.x | ローカル通知 |
| 画像選択 | image_picker | 1.x | カメラ/ギャラリーから画像選択 |
| 課金 | in_app_purchase | 3.x | App Store / Google Play課金 |
| 広告 | google_mobile_ads | 5.x | AdMobバナー広告 |
| アイコン | flutter_native_splash | 2.x | スプラッシュ画面 |
| 多言語 | flutter_localizations | - | 国際化対応 |

#### 開発・テストツール
| カテゴリ | ライブラリ | 用途 |
|----------|-----------|------|
| コード生成 | freezed | イミュータブルモデル生成 |
| JSON | json_serializable | JSON <-> Dart変換 |
| テスト | flutter_test | ユニット/ウィジェットテスト |
| モック | mockito | テスト用モック生成 |
| Lint | flutter_lints | コード品質チェック |

### アーキテクチャパターン: MVVM

```
┌─────────────────────────────────────────────────┐
│                 Presentation Layer              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │  View    │  │  View    │  │  View    │     │
│  │ (Widget) │  │ (Widget) │  │ (Widget) │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │             │             │            │
│  ┌────▼─────┐  ┌───▼──────┐  ┌───▼──────┐     │
│  │ViewModel │  │ViewModel │  │ViewModel │     │
│  │(Provider)│  │(Provider)│  │(Provider)│     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
└───────┼─────────────┼─────────────┼───────────┘
        │             │             │
┌───────▼─────────────▼─────────────▼───────────┐
│                   Domain Layer                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │Repository│  │Repository│  │Repository│     │
│  │Interface │  │Interface │  │Interface │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │             │             │            │
│  ┌────▼─────┐  ┌───▼──────┐  ┌───▼──────┐     │
│  │  Model   │  │  Model   │  │  Model   │     │
│  │ (Entity) │  │ (Entity) │  │ (Entity) │     │
│  └──────────┘  └──────────┘  └──────────┘     │
└────────────────────┬───────────────────────────┘
                     │
┌────────────────────▼───────────────────────────┐
│                   Data Layer                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │Repository│  │Repository│  │Repository│     │
│  │  Impl    │  │  Impl    │  │  Impl    │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │             │             │            │
│  ┌────▼─────┐  ┌───▼──────┐  ┌───▼──────┐     │
│  │DataSource│  │DataSource│  │DataSource│     │
│  │  (Drift) │  │  (Drift) │  │  (Drift) │     │
│  └──────────┘  └──────────┘  └──────────┘     │
└────────────────────────────────────────────────┘
```

### ディレクトリ構造（feature-first）

```
lib/
├── main.dart                          # アプリエントリーポイント
├── app.dart                           # MaterialApp設定
├── core/                              # 共通コア機能
│   ├── router/                        # go_routerルーティング設定
│   │   ├── router.dart
│   │   └── routes.dart
│   ├── theme/                         # shadcn_flutterテーマ設定
│   │   ├── app_theme.dart            # テーマ統合（ライト/ダーク）
│   │   ├── color_scheme.dart         # shadcn_flutterカラースキーム
│   │   └── typography.dart           # フォント設定
│   ├── constants/                     # 定数
│   │   ├── app_constants.dart
│   │   └── db_constants.dart
│   ├── utils/                         # ユーティリティ
│   │   ├── date_utils.dart
│   │   └── validators.dart
│   └── widgets/                       # 共通ウィジェット
│       ├── loading_indicator.dart
│       ├── error_view.dart
│       └── empty_view.dart
├── features/                          # 機能モジュール
│   ├── habit/                         # 習慣機能
│   │   ├── presentation/              # UI層
│   │   │   ├── pages/
│   │   │   │   ├── habit_list_page.dart
│   │   │   │   ├── habit_detail_page.dart
│   │   │   │   └── habit_form_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── habit_card.dart
│   │   │   │   └── habit_streak_indicator.dart
│   │   │   └── providers/             # ViewModel (Riverpod Provider)
│   │   │       ├── habit_list_provider.dart
│   │   │       └── habit_form_provider.dart
│   │   ├── domain/                    # ドメイン層
│   │   │   ├── models/
│   │   │   │   ├── habit.dart
│   │   │   │   └── habit_log.dart
│   │   │   └── repositories/
│   │   │       └── habit_repository.dart
│   │   └── data/                      # データ層
│   │       ├── repositories/
│   │       │   └── habit_repository_impl.dart
│   │       └── datasources/
│   │           └── habit_local_datasource.dart
│   ├── reward/                        # ご褒美機能
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   ├── reward_list_page.dart
│   │   │   │   ├── reward_detail_page.dart
│   │   │   │   └── reward_form_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── reward_card.dart
│   │   │   │   └── reward_progress_bar.dart
│   │   │   └── providers/
│   │   │       ├── reward_list_provider.dart
│   │   │       └── reward_form_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── reward.dart
│   │   │   │   └── reward_redemption.dart
│   │   │   └── repositories/
│   │   │       └── reward_repository.dart
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── reward_repository_impl.dart
│   │       └── datasources/
│   │           └── reward_local_datasource.dart
│   ├── wallet/                        # ポイント管理機能
│   │   ├── presentation/
│   │   │   ├── widgets/
│   │   │   │   └── wallet_balance_widget.dart
│   │   │   └── providers/
│   │   │       └── wallet_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── wallet.dart
│   │   │   └── repositories/
│   │   │       └── wallet_repository.dart
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── wallet_repository_impl.dart
│   │       └── datasources/
│   │           └── wallet_local_datasource.dart
│   ├── history/                       # 履歴機能
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── history_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── point_history_list.dart
│   │   │   │   └── redemption_history_list.dart
│   │   │   └── providers/
│   │   │       └── history_provider.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── history_repository.dart
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── history_repository_impl.dart
│   │       └── datasources/
│   │           └── history_local_datasource.dart
│   ├── notification/                  # 通知機能
│   │   ├── presentation/
│   │   │   └── providers/
│   │   │       └── notification_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── notification_settings.dart
│   │   │   └── repositories/
│   │   │       └── notification_repository.dart
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── notification_repository_impl.dart
│   │       └── datasources/
│   │           └── notification_local_datasource.dart
│   ├── settings/                      # 設定機能
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── settings_page.dart
│   │   │   ├── widgets/
│   │   │   │   └── theme_switcher.dart
│   │   │   └── providers/
│   │   │       └── settings_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── app_settings.dart
│   │   │   └── repositories/
│   │   │       └── settings_repository.dart
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── settings_repository_impl.dart
│   │       └── datasources/
│   │           └── settings_local_datasource.dart
│   ├── monetization/                  # 収益化機能
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── premium_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── ad_banner_widget.dart
│   │   │   │   └── premium_features_list.dart
│   │   │   └── providers/
│   │   │       ├── purchase_provider.dart
│   │   │       └── ad_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── premium_status.dart
│   │   │   └── repositories/
│   │   │       ├── purchase_repository.dart
│   │   │       └── ad_repository.dart
│   │   └── data/
│   │       ├── repositories/
│   │       │   ├── purchase_repository_impl.dart
│   │       │   └── ad_repository_impl.dart
│   │       └── datasources/
│   │           ├── purchase_datasource.dart
│   │           └── ad_datasource.dart
│   └── home/                          # ホーム画面
│       ├── presentation/
│       │   ├── pages/
│       │   │   └── home_page.dart
│       │   ├── widgets/
│       │   │   ├── today_habits_section.dart
│       │   │   └── top_rewards_section.dart
│       │   └── providers/
│       │       └── home_provider.dart
└── l10n/                              # 多言語対応
    ├── app_ja.arb                     # 日本語
    └── app_en.arb                     # 英語（将来）

test/                                  # テストコード
├── unit/                              # ユニットテスト
├── widget/                            # ウィジェットテスト
└── integration/                       # 結合テスト
```

## データ設計

### Driftスキーマ定義

> **Note**: 依存関係の互換性問題（`isar_generator` が `analyzer <6.0.0` のみ対応、`freezed`/`riverpod_generator` が `analyzer >=6.x` を必要とする）により、IsarからDriftに移行した。DriftはType-safeなSQLite ORM でアクティブにメンテナンスされている。

#### 1. Habits テーブル（習慣）

```dart
import 'package:drift/drift.dart';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  IntColumn get points => integer()();           // 付与ポイント
  TextColumn get frequencyType => text()();      // 'daily' or 'weekly'
  IntColumn get frequencyValue => integer()();   // 週n回の場合のn
  DateTimeColumn get remindTime => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
```

#### 2. HabitLogs テーブル（習慣達成ログ）

```dart
class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  DateTimeColumn get date => dateTime()();       // yyyy-mm-dd（時刻は00:00:00）
  IntColumn get points => integer()();           // 獲得ポイント
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date},  // 1日1回制限の複合ユニークキー
  ];
}
```

#### 3. Rewards テーブル（ご褒美）

```dart
class Rewards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  TextColumn get imageUri => text().nullable()(); // 画像パス
  IntColumn get targetPoints => integer()();      // 必要ポイント
  TextColumn get category => text().nullable()(); // 'item'/'experience'/'food'/'beauty'/'entertainment'/'other'
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
```

#### 4. RewardRedemptions テーブル（ご褒美交換履歴）

```dart
class RewardRedemptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get rewardId => integer().references(Rewards, #id)();
  IntColumn get pointsSpent => integer()();       // 消費ポイント
  DateTimeColumn get redeemedAt => dateTime()();
}
```

#### 5. Wallets テーブル（ポイント残高）

```dart
class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentPoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
}
```

#### 6. AppSettings テーブル（アプリ設定）

```dart
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))(); // 'light'/'dark'/'system'
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get locale => text().withDefault(const Constant('ja'))();
  DateTimeColumn get updatedAt => dateTime()();
}
```

#### 7. PremiumStatuses テーブル（プレミアム状態）

```dart
class PremiumStatuses extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  DateTimeColumn get premiumExpiresAt => dateTime().nullable()();
  TextColumn get purchaseToken => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

#### データベース定義

```dart
// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Habits,
  HabitLogs,
  Rewards,
  RewardRedemptions,
  Wallets,
  AppSettingsTable,
  PremiumStatuses,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hobica.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

### データフロー

```
[UI] → [Provider] → [Repository] → [DataSource] → [Drift/SQLite]
                ↑                                      ↓
                └─────────← [Stream/StateNotifier] ←──┘
```

1. **習慣達成フロー**
   ```
   User tap → HabitLogを作成 → Walletにポイント加算 → UI更新
   ```

2. **ご褒美解禁フロー**
   ```
   Walletポイント監視 → targetPoints到達検知 → 解禁状態に変更 → 通知
   ```

3. **ご褒美交換フロー**
   ```
   User tap → Walletからポイント減算 → RewardRedemption作成 → UI更新
   ```

## UI/UX設計

### デザインシステム

**shadcn_flutter**をメインUIコンポーネントライブラリとして採用。モダンで洗練されたshadcn/uiスタイルを実現。

#### 主な特徴
- **84個以上のコンポーネント**: Button、Card、Input、Select、Dialog、Toast、Progress、Tabsなど
- **10のカテゴリ**: アニメーション、フォーム入力、レイアウト、ナビゲーション、サーフェス、データ表示、フィードバックなど
- **New Yorkスタイル**: shadcn/uiの洗練されたデザインスタイル
- **Material/Cupertino非依存**: 独立したデザインシステムで一貫性のあるUI
- **ダークモード対応**: ライト/ダークテーマの自動切り替え
- **カスタマイズ可能**: アプリ独自のブランディングに対応

#### コンポーネント使用例
```dart
// shadcn_flutterのButton
Button(
  onPressed: () {},
  child: Text('習慣を追加'),
)

// shadcn_flutterのCard
Card(
  child: Column(
    children: [
      Text('読書 30分'),
      Badge(label: '30pt'),
    ],
  ),
)

// shadcn_flutterのInput
Input(
  placeholder: 'タイトルを入力',
  onChanged: (value) {},
)
```

### 画面仕様

#### 1. ホーム画面（Home）

**レイアウト**
```
┌─────────────────────────────────┐
│ ┌─────┐  hobica       🔔  ⚙️   │ ← AppBar
│ │  📊 │  1,250 pt              │ ← ポイント残高
│ └─────┘                         │
├─────────────────────────────────┤
│ 今日の習慣                 + 追加│
│ ┌─────────────────────────────┐ │
│ │ 📖 読書 30分       30pt   ✓ │ │ ← 習慣カード
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 🏃 ランニング       50pt  ☐ │ │
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ ご褒美                    全て見る│
│ ┌─────────────────────────────┐ │
│ │ 📷 [画像]                   │ │
│ │ 新しいカメラ               │ │ ← ご褒美カード
│ │ ■■■■■□□□□□  1250/2000pt │ │
│ │ あと 750pt                  │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 🎮 [画像]                   │ │
│ │ ゲームソフト               │ │
│ │ ■■□□□□□□□□  250/1500pt │ │
│ │ あと 1250pt                 │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**機能**
- ポイント残高表示（常時上部固定）
- 今日の習慣一覧（達成ボタン付き）
- ご褒美進捗（上位3つ表示）
- 習慣追加/ご褒美追加ボタン

**shadcn_flutter コンポーネント**
- **AppBar**: shadcn Header with Avatar（アプリアイコン）とBadge（ポイント表示）
- **習慣カード**: Card with Checkbox（達成状態）、Badge（ポイント表示）
- **ご褒美カード**: Card with Image、Progress（進捗バー）、Badge（残りポイント）
- **追加ボタン**: Button（プライマリスタイル）
- **全体レイアウト**: ScrollArea（スクロール可能）

#### 2. 習慣一覧画面（Habit List）

**レイアウト**
```
┌─────────────────────────────────┐
│ ← 習慣一覧              + 追加   │ ← AppBar
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ 📖 読書 30分               │ │
│ │ 毎日 | 30pt | 🔥 7日連続   │ │ ← Streak表示
│ │ ✓ 今日達成済み              │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 🏃 ランニング              │ │
│ │ 毎日 | 50pt | 🔥 3日連続   │ │
│ │ ☐ 未達成                    │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**機能**
- 習慣一覧（タイトル、頻度、付与pt、連続達成）
- 達成状態表示（✓済み / ☐未）
- タップで詳細画面へ
- 長押しで編集/削除メニュー

#### 3. 習慣詳細画面（Habit Detail）

**レイアウト**
```
┌─────────────────────────────────┐
│ ← 読書 30分             編集 🗑  │ ← AppBar
├─────────────────────────────────┤
│ 📖 読書 30分                    │
│ 毎日 | 30pt                     │
│ 🔥 連続 7日達成                 │
├─────────────────────────────────┤
│ カレンダー                      │
│ ┌─────────────────────────────┐ │
│ │ 2026年2月                    │ │
│ │ 日 月 火 水 木 金 土        │ │
│ │          1  2  3  4  5  6  7│ │
│ │ ✓  ✓  ✓  ✓  ✓  ✓  ✓        │ │ ← 達成日にチェック
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ リマインド                      │
│ 🔔 毎日 20:00                   │ ← 通知設定
└─────────────────────────────────┘
```

**機能**
- 習慣詳細情報
- カレンダー表示（達成日にチェックマーク）
- 連続達成日数（Streak）
- リマインド設定
- 編集/削除

#### 4. 習慣作成/編集画面（Habit Form）

**レイアウト**
```
┌─────────────────────────────────┐
│ × 習慣を追加                    │ ← AppBar
├─────────────────────────────────┤
│ タイトル                        │
│ ┌─────────────────────────────┐ │
│ │ 読書 30分                    │ │ ← TextField
│ └─────────────────────────────┘ │
│                                 │
│ 頻度                            │
│ ┌─────────────────────────────┐ │
│ │ ● 毎日  ○ 週n回             │ │ ← ラジオボタン
│ └─────────────────────────────┘ │
│                                 │
│ 付与ポイント                    │
│ ┌─────────────────────────────┐ │
│ │ 30                           │ │ ← 数値入力
│ └─────────────────────────────┘ │
│                                 │
│ リマインド（任意）              │
│ ┌─────────────────────────────┐ │
│ │ 🔔 20:00                     │ │ ← 時刻選択
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │         保存する            │ │ ← 保存ボタン
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**バリデーション**
- タイトル: 必須、1-50文字
- 付与ポイント: 必須、1以上の整数
- 頻度: 必須

#### 5. ご褒美一覧画面（Reward List）

**レイアウト**
```
┌─────────────────────────────────┐
│ ← ご褒美一覧            + 追加   │ ← AppBar
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ 📷 [画像]                   │ │
│ │ 新しいカメラ               │ │
│ │ 物品                        │ │
│ │ ■■■■■□□□□□  1250/2000pt │ │ ← 進捗バー
│ │ あと 750pt                  │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 🎮 [画像]                   │ │
│ │ ゲームソフト               │ │
│ │ 娯楽                        │ │
│ │ ■■□□□□□□□□  250/1500pt │ │
│ │ あと 1250pt                 │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**機能**
- ご褒美一覧（画像、タイトル、カテゴリ、進捗）
- 進捗バーとあと何pt表示
- タップで詳細画面へ
- 長押しで編集/削除メニュー

#### 6. ご褒美詳細画面（Reward Detail）

**レイアウト**
```
┌─────────────────────────────────┐
│ ← 新しいカメラ         編集 🗑  │ ← AppBar
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │                             │ │
│ │        [画像拡大表示]       │ │ ← 画像
│ │                             │ │
│ └─────────────────────────────┘ │
│                                 │
│ 新しいカメラ                    │
│ カテゴリ: 物品                  │
│                                 │
│ 進捗                            │
│ ■■■■■□□□□□  1250 / 2000pt │
│ あと 750pt                      │
│                                 │
│ メモ                            │
│ Canon EOS R6 Mark II            │
│ 価格: 約40万円                  │
│                                 │
│ ┌─────────────────────────────┐ │
│ │     まだ解禁できません      │ │ ← 解禁前はグレーアウト
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**解禁後の表示**
```
│ ┌─────────────────────────────┐ │
│ │  🎉 解禁！ 交換する          │ │ ← 解禁後はアクティブ
│ └─────────────────────────────┘ │
```

**機能**
- 画像拡大表示
- 進捗詳細
- 解禁/交換ボタン（条件達成で有効化）
- 編集/削除

#### 7. ご褒美作成/編集画面（Reward Form）

**レイアウト**
```
┌─────────────────────────────────┐
│ × ご褒美を追加                  │ ← AppBar
├─────────────────────────────────┤
│ 画像（任意）                    │
│ ┌─────────────────────────────┐ │
│ │      [画像プレビュー]       │ │ ← 画像選択
│ │  📷 写真を選択  📸 撮影     │ │
│ └─────────────────────────────┘ │
│                                 │
│ タイトル                        │
│ ┌─────────────────────────────┐ │
│ │ 新しいカメラ                 │ │ ← TextField
│ └─────────────────────────────┘ │
│                                 │
│ 必要ポイント                    │
│ ┌─────────────────────────────┐ │
│ │ 2000                         │ │ ← 数値入力
│ └─────────────────────────────┘ │
│                                 │
│ カテゴリ（任意）                │
│ ┌─────────────────────────────┐ │
│ │ 物品 ▼                       │ │ ← ドロップダウン
│ └─────────────────────────────┘ │
│                                 │
│ メモ（任意）                    │
│ ┌─────────────────────────────┐ │
│ │ Canon EOS R6 Mark II...      │ │ ← 複数行TextField
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │         保存する            │ │ ← 保存ボタン
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**バリデーション**
- タイトル: 必須、1-50文字
- 必要ポイント: 必須、1以上の整数

#### 8. 履歴画面（History）

**レイアウト**
```
┌─────────────────────────────────┐
│ ← 履歴                          │ ← AppBar
├─────────────────────────────────┤
│ ┌─ ポイント獲得 ─┬─ 交換 ────┐ │ ← タブ
│ │  📊 ポイント獲得             │ │
│ │                             │ │
│ │ 2026年2月16日               │ │
│ │ ┌─────────────────────────┐ │ │
│ │ │ 📖 読書 30分    +30pt   │ │ │ ← ポイント獲得ログ
│ │ └─────────────────────────┘ │ │
│ │ ┌─────────────────────────┐ │ │
│ │ │ 🏃 ランニング   +50pt   │ │ │
│ │ └─────────────────────────┘ │ │
│ │                             │ │
│ │ 2026年2月15日               │ │
│ │ ┌─────────────────────────┐ │ │
│ │ │ 📖 読書 30分    +30pt   │ │ │
│ │ └─────────────────────────┘ │ │
└─┴─────────────────────────────┴─┘
```

**交換タブ**
```
│ ┌─ ポイント獲得 ─┬─ 交換 ────┐ │
│ │               📦 交換履歴   │ │
│ │                             │ │
│ │ 2026年2月10日               │ │
│ │ ┌─────────────────────────┐ │ │
│ │ │ 📷 新しいカメラ -2000pt │ │ │ ← 交換ログ
│ │ └─────────────────────────┘ │ │
└─┴─────────────────────────────┴─┘
```

**機能**
- タブ切り替え（ポイント獲得 / 交換）
- 日付でグループ化
- 獲得/消費ポイント表示

#### 9. 設定画面（Settings）

**レイアウト**
```
┌─────────────────────────────────┐
│ ← 設定                          │ ← AppBar
├─────────────────────────────────┤
│ テーマ                          │
│ ┌─────────────────────────────┐ │
│ │ 🌙 ダークモード      [Toggle]│ │ ← スイッチ
│ └─────────────────────────────┘ │
│                                 │
│ 通知                            │
│ ┌─────────────────────────────┐ │
│ │ 🔔 リマインド通知    [Toggle]│ │
│ └─────────────────────────────┘ │
│                                 │
│ プレミアム                      │
│ ┌─────────────────────────────┐ │
│ │ ⭐ プレミアムにアップグレード│ │ ← プレミアムへ誘導
│ └─────────────────────────────┘ │
│                                 │
│ データ                          │
│ ┌─────────────────────────────┐ │
│ │ 📤 データをエクスポート      │ │ ← 将来機能
│ │ 📥 データをインポート        │ │
│ └─────────────────────────────┘ │
│                                 │
│ その他                          │
│ ┌─────────────────────────────┐ │
│ │ 📄 利用規約                  │ │
│ │ 🔒 プライバシーポリシー      │ │
│ │ ℹ️  アプリについて            │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**機能**
- テーマ切り替え（ライト/ダーク/システム）
- 通知設定のON/OFF
- プレミアムへのアップグレード誘導
- データエクスポート/インポート（将来）
- 利用規約、プライバシーポリシー

#### 10. プレミアム画面（Premium）

**レイアウト**
```
┌─────────────────────────────────┐
│ × プレミアム                    │ ← AppBar
├─────────────────────────────────┤
│ ⭐ hobica プレミアム             │
│                                 │
│ プレミアム機能                  │
│ ┌─────────────────────────────┐ │
│ │ ✓ 習慣・ご褒美 無制限        │ │
│ │ ✓ 広告なし                   │ │
│ │ ✓ テーマ・デザインカスタマイズ│ │
│ │ ✓ 週/月レポート               │ │
│ │ ✓ データバックアップ         │ │
│ │ ✓ ウィジェット（今後追加）   │ │
│ └─────────────────────────────┘ │
│                                 │
│ 料金プラン                      │
│ ┌─────────────────────────────┐ │
│ │ 月額 ¥480                    │ │ ← 課金プラン
│ │ まずは無料で試す             │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │   プレミアムに登録する       │ │ ← 購入ボタン
│ └─────────────────────────────┘ │
│                                 │
│ ※ 自動更新されます。いつでも解約可能です。│
└─────────────────────────────────┘
```

**機能**
- プレミアム機能一覧
- 料金プラン表示
- App Store / Google Play課金フロー
- 購入後の復元処理

### 画面遷移図

```
┌─────────────┐
│    Home     │ ← 起動時
└─────┬───────┘
      │
      ├─→ ┌──────────────┐
      │   │  Habit List  │
      │   └─────┬────────┘
      │         │
      │         ├─→ ┌──────────────┐
      │         │   │ Habit Detail │
      │         │   └──────────────┘
      │         │
      │         └─→ ┌──────────────┐
      │             │  Habit Form  │
      │             └──────────────┘
      │
      ├─→ ┌──────────────┐
      │   │ Reward List  │
      │   └─────┬────────┘
      │         │
      │         ├─→ ┌──────────────┐
      │         │   │Reward Detail │
      │         │   └──────────────┘
      │         │
      │         └─→ ┌──────────────┐
      │             │ Reward Form  │
      │             └──────────────┘
      │
      ├─→ ┌──────────────┐
      │   │   History    │
      │   └──────────────┘
      │
      ├─→ ┌──────────────┐
      │   │   Settings   │
      │   └─────┬────────┘
      │         │
      │         └─→ ┌──────────────┐
      │             │   Premium    │
      │             └──────────────┘
      │
      └─→ 通知タップ → 該当習慣の詳細画面
```

### ナビゲーション

**shadcn_flutter Tabs（ボトムナビゲーション）**

モダンなタブナビゲーションを実装。shadcn_flutterのTabsコンポーネントを使用。

```dart
Tabs(
  tabs: [
    Tab(icon: Icon(Icons.home), label: 'ホーム'),
    Tab(icon: Icon(Icons.check_circle), label: '習慣'),
    Tab(icon: Icon(Icons.card_giftcard), label: 'ご褒美'),
    Tab(icon: Icon(Icons.history), label: '履歴'),
    Tab(icon: Icon(Icons.settings), label: '設定'),
  ],
  // タブ切り替え時の処理
)
```

| タブ | アイコン | ラベル | 遷移先 |
|------|----------|--------|--------|
| 1 | 🏠 | ホーム | Home |
| 2 | ✅ | 習慣 | Habit List |
| 3 | 🎁 | ご褒美 | Reward List |
| 4 | 📊 | 履歴 | History |
| 5 | ⚙️ | 設定 | Settings |

## セキュリティ設計

### データ保護

#### ローカルデータベース暗号化
```dart
// Driftでのデータベース初期化（将来: SQLCipherで暗号化対応）
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hobica.sqlite'));
    // 将来: NativeDatabase.createInBackground(file, setup: (db) {
    //   db.execute("PRAGMA key = '$encryptionKey'");  // SQLCipher
    // });
    return NativeDatabase.createInBackground(file);
  });
}

// 暗号化キー管理（将来機能）
Future<String> _getEncryptionKey() async {
  // flutter_secure_storageを使用
  const storage = FlutterSecureStorage();
  String? key = await storage.read(key: 'db_encryption_key');

  if (key == null) {
    final random = Random.secure();
    key = base64Encode(
      Uint8List.fromList(List.generate(32, (_) => random.nextInt(256))),
    );
    await storage.write(key: 'db_encryption_key', value: key);
  }

  return key;
}
```

### 不正対策

#### 習慣達成の連打防止

```dart
// HabitRepositoryImpl
Future<Result<void, AppError>> completeHabit(int habitId) async {
  final today = DateTime.now().toDate(); // 時刻を00:00:00に正規化

  // 既に今日達成済みかチェック（UNIQUE制約でDBレベルでも保護）
  final existingLog = await (db.select(db.habitLogs)
    ..where((t) => t.habitId.equals(habitId) & t.date.equals(today)))
    .getSingleOrNull();

  if (existingLog != null) {
    return Failure(AppError.alreadyCompleted('今日は既に達成済みです'));
  }

  // HabitLog作成とWallet更新をトランザクションで実行
  await db.transaction(() async {
    // ログ作成
    await db.into(db.habitLogs).insert(HabitLogsCompanion.insert(
      habitId: habitId,
      date: today,
      points: habit.points,
      createdAt: DateTime.now(),
    ));

    // Wallet更新
    await (db.update(db.wallets)..where((t) => t.id.equals(1))).write(
      WalletsCompanion(
        currentPoints: Value(currentPoints + habit.points),
        updatedAt: Value(DateTime.now()),
      ),
    );
  });

  return Success(null);
}
```

#### 端末時刻変更検知（将来機能）

```dart
// 将来: サーバー時刻との比較
Future<bool> isDeviceTimeValid() async {
  try {
    final serverTime = await fetchServerTime(); // API呼び出し
    final deviceTime = DateTime.now();
    final diff = deviceTime.difference(serverTime).abs();

    // 5分以上のズレは不正とみなす
    return diff.inMinutes < 5;
  } catch (e) {
    // サーバー通信失敗時はローカル時刻を信用
    return true;
  }
}
```

### プライバシー

#### データエクスポート（将来機能）

```dart
Future<String> exportData() async {
  final habits = await db.select(db.habits).get();
  final habitLogs = await db.select(db.habitLogs).get();
  final rewards = await db.select(db.rewards).get();
  final redemptions = await db.select(db.rewardRedemptions).get();
  final wallet = await (db.select(db.wallets)..where((t) => t.id.equals(1))).getSingle();

  final data = {
    'version': '1.0',
    'exportedAt': DateTime.now().toIso8601String(),
    'habits': habits.map((h) => h.toJson()).toList(),
    'habitLogs': habitLogs.map((l) => l.toJson()).toList(),
    'rewards': rewards.map((r) => r.toJson()).toList(),
    'redemptions': redemptions.map((r) => r.toJson()).toList(),
    'wallet': wallet.toJson(),
  };

  return jsonEncode(data);
}
```

## パフォーマンス設計

### 最適化戦略

#### Driftインデックス最適化

```dart
// テーブル定義でインデックスを指定
class HabitLogs extends Table {
  // ...
  @override
  List<Index> get indexes => [
    Index('habit_date_idx', [habitId, date]),  // 複合インデックス
  ];
}

class Rewards extends Table {
  // ...
  @override
  List<Index> get indexes => [
    Index('rewards_active_idx', [isActive]),   // アクティブ絞り込み用
  ];
}
```

#### ページネーション（将来: 大量データ対応）

```dart
// 履歴表示のページネーション
Future<List<HabitLog>> fetchHabitLogs({
  required int offset,
  required int limit,
}) async {
  return (db.select(db.habitLogs)
    ..orderBy([(t) => OrderingTerm.desc(t.date)])
    ..limit(limit, offset: offset))
    .get();
}
```

#### 画像最適化

```dart
// 画像圧縮とリサイズ
Future<String> saveRewardImage(File imageFile) async {
  final dir = await getApplicationDocumentsDirectory();
  final uuid = Uuid().v4();
  final path = '${dir.path}/rewards/$uuid.jpg';

  // flutter_image_compressで圧縮
  final compressedImage = await FlutterImageCompress.compressAndGetFile(
    imageFile.absolute.path,
    path,
    quality: 85,
    minWidth: 800,
    minHeight: 800,
  );

  return compressedImage!.path;
}
```

### キャッシング

#### Riverpodによる状態キャッシュ

```dart
// HabitListProviderでキャッシュ
@riverpod
class HabitList extends _$HabitList {
  @override
  Future<List<Habit>> build() async {
    final repository = ref.watch(habitRepositoryProvider);
    return repository.fetchAllHabits();
  }

  // Riverpodが自動的にキャッシュを管理
  // invalidate()で明示的にリフレッシュ可能
}
```

## 開発・運用

### 開発環境セットアップ

#### 必要要件
- Flutter SDK: 3.27.x以上
- Dart SDK: 3.6.x以上
- Android Studio / Xcode
- FVM（Flutter Version Management）推奨

#### セットアップ手順

```bash
# 1. リポジトリクローン
git clone https://github.com/your-org/hobica.git
cd hobica

# 2. FVMでFlutterバージョン固定
fvm install 3.27.0
fvm use 3.27.0

# 3. 依存パッケージインストール（shadcn_flutter含む）
fvm flutter pub get

# 4. コード生成（freezed, json_serializable, drift）
fvm dart run build_runner build --delete-conflicting-outputs

# 5. 実行
fvm flutter run

# Tips: shadcn_flutterのコンポーネントは自動でインポート可能
# import 'package:shadcn_flutter/shadcn_flutter.dart';
```

### CI/CDパイプライン

#### GitHub Actions設定例

```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.27.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Analyze code
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  build-android:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.27.0'
      - run: flutter pub get
      - run: flutter build apk --release

  build-ios:
    runs-on: macos-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.27.0'
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
```

### モニタリング・ロギング

#### ロギング戦略

```dart
// logger パッケージを使用
final logger = Logger(
  printer: PrettyPrinter(),
  level: kDebugMode ? Level.debug : Level.info,
);

// 使用例
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message', error, stackTrace);
```

#### クラッシュレポート（将来: Firebase Crashlytics）

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化（将来）
  // await Firebase.initializeApp();

  // Crashlytics設定（将来）
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded(
    () => runApp(ProviderScope(child: MyApp())),
    (error, stack) {
      // エラーログ記録（将来: Crashlyticsへ送信）
      logger.e('Uncaught error', error, stack);
    },
  );
}
```

## エラー戦略

### エラー分類

#### 1. 回復可能エラー
- ネットワークエラー（将来: API通信時）
- ファイルI/Oエラー（一時的な権限不足等）
- バリデーションエラー

**対処**: リトライ、ユーザーへのフィードバック、フォールバック

#### 2. 回復不可能エラー
- データベース破損
- 必須リソースの欠落
- プログラムバグ

**対処**: エラー画面表示、アプリ再起動促進、クラッシュレポート送信

### エラーハンドリング方針

#### Result型の使用

```dart
// freezedでResult型定義
@freezed
class Result<T, E> with _$Result<T, E> {
  const factory Result.success(T value) = Success<T, E>;
  const factory Result.failure(E error) = Failure<T, E>;
}

// 使用例
Future<Result<Habit, AppError>> createHabit(HabitsCompanion companion) async {
  try {
    // バリデーション
    if (companion.title.value.isEmpty) {
      return Failure(AppError.validation('タイトルを入力してください'));
    }

    // DB保存
    final id = await db.into(db.habits).insert(companion);
    final created = await (db.select(db.habits)
      ..where((t) => t.id.equals(id)))
      .getSingle();

    return Success(created);
  } catch (e, stack) {
    logger.e('Failed to create habit', e, stack);
    return Failure(AppError.unknown('習慣の作成に失敗しました'));
  }
}
```

#### AppError定義

```dart
@freezed
class AppError with _$AppError {
  const factory AppError.validation(String message) = ValidationError;
  const factory AppError.notFound(String message) = NotFoundError;
  const factory AppError.alreadyCompleted(String message) = AlreadyCompletedError;
  const factory AppError.insufficientPoints(String message) = InsufficientPointsError;
  const factory AppError.unknown(String message) = UnknownError;
}
```

### リトライポリシー

#### 指数バックオフ（将来: API通信時）

```dart
Future<T> retryWithBackoff<T>({
  required Future<T> Function() action,
  int maxRetries = 3,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  int retryCount = 0;
  Duration delay = initialDelay;

  while (true) {
    try {
      return await action();
    } catch (e) {
      if (retryCount >= maxRetries) {
        rethrow;
      }

      logger.w('Retry $retryCount after ${delay.inSeconds}s', e);
      await Future.delayed(delay);

      retryCount++;
      delay *= 2; // 指数バックオフ
    }
  }
}
```

### エラーログ・通知

#### ログレベル基準

| レベル | 用途 | 例 |
|--------|------|-----|
| DEBUG | 開発時のデバッグ情報 | データベースクエリ内容 |
| INFO | 通常の動作ログ | 習慣達成、ご褒美交換 |
| WARN | 警告（動作は継続） | リトライ実行、フォールバック |
| ERROR | エラー（一部機能停止） | データベースエラー、バリデーション失敗 |
| FATAL | 致命的エラー（アプリクラッシュ） | 未捕捉例外 |

## テスト戦略

### テストピラミッド

```
        /\
       /E2E\        10% - 統合テスト（主要フロー）
      /------\
     /Widget \      30% - ウィジェットテスト（UI）
    /----------\
   /   Unit     \   60% - ユニットテスト（ロジック）
  /--------------\
```

### カバレッジ目標

- **全体**: 80%以上
- **ビジネスロジック（Repository, UseCase）**: 90%以上
- **ViewModel（Provider）**: 85%以上
- **ウィジェット**: 70%以上

### テストデータ戦略

#### フィクスチャ

```dart
// test/fixtures/habit_fixtures.dart
class HabitFixtures {
  static Habit dailyReading() => Habit()
    ..id = 1
    ..title = '読書 30分'
    ..points = 30
    ..frequencyType = FrequencyType.daily
    ..frequencyValue = 1
    ..createdAt = DateTime(2026, 2, 1)
    ..isActive = true;

  static Habit weeklyRunning() => Habit()
    ..id = 2
    ..title = 'ランニング'
    ..points = 50
    ..frequencyType = FrequencyType.weekly
    ..frequencyValue = 3
    ..createdAt = DateTime(2026, 2, 1)
    ..isActive = true;
}
```

#### モック

```dart
// test/mocks/mock_habit_repository.dart
@GenerateMocks([HabitRepository])
void main() {
  late MockHabitRepository mockRepository;

  setUp(() {
    mockRepository = MockHabitRepository();
  });

  test('習慣一覧取得', () async {
    // モック設定
    when(mockRepository.fetchAllHabits())
      .thenAnswer((_) async => [
        HabitFixtures.dailyReading(),
        HabitFixtures.weeklyRunning(),
      ]);

    // テスト実行
    final result = await mockRepository.fetchAllHabits();

    // 検証
    expect(result.length, 2);
    verify(mockRepository.fetchAllHabits()).called(1);
  });
}
```

### テスト例

#### ユニットテスト

```dart
// test/features/habit/domain/models/habit_test.dart
void main() {
  group('Habit', () {
    test('毎日習慣の作成', () {
      final habit = Habit()
        ..title = '読書'
        ..points = 30
        ..frequencyType = FrequencyType.daily
        ..frequencyValue = 1
        ..createdAt = DateTime.now()
        ..isActive = true;

      expect(habit.title, '読書');
      expect(habit.points, 30);
      expect(habit.frequencyType, FrequencyType.daily);
    });
  });
}
```

#### ウィジェットテスト

```dart
// test/features/habit/presentation/widgets/habit_card_test.dart
void main() {
  testWidgets('HabitCard表示テスト', (tester) async {
    final habit = HabitFixtures.dailyReading();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HabitCard(habit: habit),
        ),
      ),
    );

    // タイトル表示確認
    expect(find.text('読書 30分'), findsOneWidget);

    // ポイント表示確認
    expect(find.text('30pt'), findsOneWidget);

    // 達成ボタン確認
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });
}
```

#### 統合テスト

```dart
// integration_test/habit_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('習慣作成→達成→ポイント獲得フロー', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // ホーム画面表示確認
    expect(find.text('hobica'), findsOneWidget);

    // 習慣追加ボタンタップ
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // 習慣作成フォーム入力
    await tester.enterText(find.byType(TextField).first, '読書 30分');
    await tester.enterText(find.byType(TextField).at(1), '30');

    // 保存ボタンタップ
    await tester.tap(find.text('保存する'));
    await tester.pumpAndSettle();

    // 習慣一覧に表示確認
    expect(find.text('読書 30分'), findsOneWidget);

    // 達成ボタンタップ
    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    // ポイント加算確認
    expect(find.text('30 pt'), findsOneWidget);
  });
}
```

### CI統合

#### テスト実行タイミング
- **PR作成時**: 全テスト実行
- **mainブランチマージ時**: 全テスト + カバレッジレポート
- **定期実行**: 毎日深夜に全テスト（リグレッション検知）

#### 失敗時の動作
- **テスト失敗**: PRマージブロック
- **カバレッジ低下**: 警告コメント（ブロックはしない）
- **ビルド失敗**: PRマージブロック

## 制約と前提

### 技術的制約

#### Flutter/Dart
- Flutter SDK: 3.27.x以上
- Dart SDK: 3.6.x以上
- Null Safety: 必須

#### プラットフォーム
- **iOS**: 14.0以上
- **Android**: API Level 21（Android 5.0）以上

#### ライブラリ依存
- Riverpod: 状態管理の中核
- Drift: type-safe SQLite ORM（`isar_generator`との`analyzer`バージョン競合により移行）
- go_router: ルーティングの中核

### ビジネス制約

#### MVP開発期間
- **設計フェーズ**: 1週間
- **実装フェーズ**: 6-8週間
  - Week 1-2: 基盤（DB、状態管理、ルーティング）
  - Week 3-4: コア機能（習慣、ご褒美、ポイント）
  - Week 5-6: UI/UX、通知、履歴
  - Week 7-8: 収益化、テスト、バグ修正
- **テストフェーズ**: 2週間
- **リリース準備**: 1週間

**合計**: 約10-12週間

#### リソース制約
- 開発者: 1-2名想定
- デザイナー: 外注または既存デザインシステム活用
- インフラ: 初期は不要（ローカルのみ）

### 依存関係

#### 外部サービス
- **App Store Connect**: iOS課金処理
- **Google Play Console**: Android課金処理
- **AdMob**: 広告配信
- **Firebase**: 将来のバックエンド（クラウド同期、認証、Crashlytics）

#### 開発ツール
- **GitHub**: ソースコード管理
- **GitHub Actions**: CI/CD
- **Figma**: デザイン（推奨）
- **Codecov**: カバレッジレポート

## 参照

### 次のステップ
1. **DESIGN.md承認**: このドキュメントをレビュー・承認
2. **タスク分解**: `planning-tasks`スキルでTODO.mdを生成
3. **開発開始**: TDD（テスト駆動開発）で実装

### 関連ドキュメント
- `TODO.md`: タスク一覧（planning-tasksスキルで生成予定）
- `README.md`: プロジェクト概要、セットアップ手順
- `CONTRIBUTING.md`: コントリビューションガイド

### 参考リンク
- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [shadcn_flutter公式ドキュメント](https://flutter-shadcn-ui.mariuti.com/)
- [shadcn_flutter - pub.dev](https://pub.dev/packages/shadcn_flutter)
- [Riverpod公式ドキュメント](https://riverpod.dev)
- [Drift公式ドキュメント](https://drift.simonbinder.eu)
- [go_router公式ドキュメント](https://pub.dev/packages/go_router)

---

**Document Version**: 1.2
**Last Updated**: 2026-02-17
**Status**: Draft（承認待ち）
**更新履歴**:
- v1.2: データベースをIsarからDriftに変更（`isar_generator`と`analyzer`のバージョン非互換問題を解消）
- v1.1: UIフレームワークをshadcn_flutterに変更（モダンなデザインシステム採用）
- v1.0: 初版作成
