# セットアップ検証ドキュメント

このドキュメントは、フェーズ0（プロジェクト初期化）で作成したファイルの検証手順を記載しています。

## 作成済みファイル一覧

### 1. プロジェクト設定ファイル

| ファイル | 目的 | 状態 |
|---------|------|------|
| `pubspec.yaml` | Flutterプロジェクト設定と依存パッケージ定義 | ✅ 作成済み |
| `.fvmrc` | Flutter バージョン固定（3.27.0） | ✅ 作成済み |
| `.gitignore` | Git除外設定（Flutter標準 + 追加設定） | ✅ 作成済み |
| `analysis_options.yaml` | Flutter Lint設定（厳格なルール適用） | ✅ 作成済み |

### 2. ドキュメント

| ファイル | 目的 | 状態 |
|---------|------|------|
| `README.md` | プロジェクト概要とセットアップ手順 | ✅ 作成済み |

### 3. ディレクトリ構造

| ディレクトリ | 目的 | 状態 |
|------------|------|------|
| `assets/images/` | 画像アセット格納 | ✅ 作成済み（.gitkeep配置） |

## 依存パッケージ一覧（pubspec.yaml）

### プロダクション依存

| カテゴリ | パッケージ | バージョン | 用途 |
|---------|-----------|-----------|------|
| State Management | flutter_riverpod | ^2.6.1 | 状態管理 |
| State Management | riverpod_annotation | ^2.6.1 | Riverpodコード生成 |
| Routing | go_router | ^14.6.2 | 宣言的ルーティング |
| Database | isar | ^3.1.8 | NoSQLデータベース |
| Database | isar_flutter_libs | ^3.1.8 | Isarネイティブライブラリ |
| Database | path_provider | ^2.1.5 | ファイルパス取得 |
| UI Components | shadcn_flutter | ^0.2.8 | モダンUIコンポーネント（84+） |
| Notification | flutter_local_notifications | ^18.0.1 | ローカル通知 |
| Notification | timezone | ^0.9.4 | タイムゾーン処理 |
| Image | image_picker | ^1.1.2 | カメラ/ギャラリー選択 |
| Image | flutter_image_compress | ^2.3.0 | 画像圧縮 |
| Purchase | in_app_purchase | ^3.2.0 | アプリ内課金 |
| Ads | google_mobile_ads | ^5.2.0 | AdMob広告 |
| Splash | flutter_native_splash | ^2.4.3 | スプラッシュスクリーン |
| Localization | flutter_localizations | SDK | 国際化対応 |
| Localization | intl | ^0.19.0 | 国際化ユーティリティ |
| Code Gen | freezed_annotation | ^2.4.4 | Freezedアノテーション |
| Code Gen | json_annotation | ^4.9.0 | JSONシリアライズ |
| Logging | logger | ^2.5.0 | ログ出力 |
| Utilities | uuid | ^4.5.1 | UUID生成 |
| Security | flutter_secure_storage | ^9.2.2 | 安全なストレージ（暗号化キー管理） |

**合計**: 21パッケージ（TODO.mdで要求された18+を満たす）

### 開発依存

| カテゴリ | パッケージ | バージョン | 用途 |
|---------|-----------|-----------|------|
| Linting | flutter_lints | ^5.0.0 | コード品質チェック |
| Code Gen | build_runner | ^2.4.13 | コード生成ツール |
| Code Gen | riverpod_generator | ^2.6.2 | Riverpodコード生成 |
| Code Gen | freezed | ^2.5.7 | イミュータブルモデル生成 |
| Code Gen | json_serializable | ^6.8.0 | JSONシリアライズ生成 |
| Code Gen | isar_generator | ^3.1.8 | Isarスキーマ生成 |
| Testing | mockito | ^5.4.4 | モック生成 |
| Testing | integration_test | SDK | 統合テスト |

**合計**: 8パッケージ

## Flutter CLIを使った検証手順

以下の手順は、Flutter環境が利用可能になった後に実行してください。

### 1. FVMセットアップ

```bash
# FVMインストール（未インストールの場合）
dart pub global activate fvm

# Flutterバージョンインストール
fvm install 3.27.0

# プロジェクトで使用
fvm use 3.27.0
```

### 2. Flutterプロジェクト作成

```bash
# 現在のディレクトリでプロジェクト作成
fvm flutter create --org com.hobica --platforms ios,android .

# 注意: pubspec.yamlが上書きされた場合
git checkout pubspec.yaml
```

### 3. 依存パッケージインストール

```bash
fvm flutter pub get
```

**期待される結果**:
- すべてのパッケージが正常にダウンロードされる
- エラーや警告が出ないこと
- `pubspec.lock`ファイルが生成される

### 4. コード生成

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

**期待される結果**:
- 現段階では生成対象ファイルがないため、警告が出る可能性があるが正常
- フェーズ2以降でモデルを作成後、再度実行して検証

### 5. Lint実行

```bash
fvm flutter analyze
```

**期待される結果**:
- 現段階ではDartファイルがないため、問題なし
- `analysis_options.yaml`が正しく読み込まれることを確認

### 6. ビルド確認

```bash
# iOSビルド（Mac環境のみ）
fvm flutter build ios --debug --no-codesign

# Androidビルド
fvm flutter build apk --debug
```

**期待される結果**:
- ビルドが成功すること（現段階ではFlutter標準のサンプルアプリ）

## フェーズ0完了チェックリスト

| 要件 | 状態 | 備考 |
|------|------|------|
| Flutterプロジェクト作成 | 🟡 保留 | Flutter CLI不可のため、README.mdに手順記載 |
| FVMバージョン固定（3.27.0） | ✅ 完了 | `.fvmrc`作成済み |
| .gitignore設定 | ✅ 完了 | Flutter標準 + 追加設定 |
| pubspec.yaml依存パッケージ追加 | ✅ 完了 | 21パッケージ（18+を満たす） |
| flutter pub get実行 | 🟡 保留 | Flutter CLI不可のため、README.mdに手順記載 |

**ステータス**: 実行可能な範囲で完了。Flutter環境準備後、保留項目を実行してフェーズ0を完全に完了させる。

## 次のステップ

1. Flutter SDK 3.27.0 をインストール（FVM推奨）
2. `fvm flutter create .` でプロジェクト骨組みを生成
3. `fvm flutter pub get` で依存パッケージをインストール
4. フェーズ1「プロジェクト構造のセットアップ」へ進む

詳細は [README.md](README.md) および [docs/TODO.md](docs/TODO.md) を参照してください。
