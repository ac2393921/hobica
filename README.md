# hobica

習慣を継続した結果として「ご褒美を解禁」し、継続を後押しするiOS/Androidアプリ。

## プロジェクト概要

hobicaは、習慣継続のモチベーション維持と衝動買い抑制を支援する習慣トラッキングアプリです。
習慣を達成してポイントを貯め、そのポイントでご褒美を「解禁」する仕組みで、楽しく習慣化をサポートします。

### 主な機能

- **習慣管理**: 毎日の習慣を登録・達成記録
- **ポイントシステム**: 習慣達成でポイント獲得
- **ご褒美管理**: 欲しいものを登録し、ポイントで解禁
- **リマインド通知**: 習慣を忘れないための通知
- **履歴表示**: ポイント獲得・交換履歴
- **テーマ切り替え**: ライト/ダークモード対応

## 技術スタック

- **Framework**: Flutter 3.27.x
- **Language**: Dart 3.6.x
- **State Management**: Riverpod 2.x
- **Database**: Isar 3.x (NoSQL)
- **Routing**: go_router 14.x
- **UI Components**: shadcn_flutter (84+ components)

詳細な技術仕様は [DESIGN.md](docs/DESIGN.md) を参照してください。

## セットアップ手順

### 前提条件

- Flutter SDK: 3.27.0以上
- Dart SDK: 3.6.0以上
- FVM（Flutter Version Management）推奨
- Android Studio または Xcode

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd hobica
```

### 2. FVMでFlutterバージョンを固定

```bash
# FVMのインストール（未インストールの場合）
dart pub global activate fvm

# Flutter 3.27.0をインストール
fvm install 3.27.0

# プロジェクトで使用するバージョンを設定
fvm use 3.27.0
```

### 3. Flutterプロジェクトの作成

**重要**: 現在のディレクトリには設定ファイルのみが存在します。
以下のコマンドでFlutterプロジェクトの骨組みを生成してください。

```bash
# プロジェクトを作成（既存の設定ファイルは保持されます）
fvm flutter create --org com.hobica --platforms ios,android .

# または、FVMを使わない場合
flutter create --org com.hobica --platforms ios,android .
```

**注意**:
- プロジェクト作成時、既存の `pubspec.yaml`, `.gitignore`, `.fvmrc` は上書きされません
- `pubspec.yaml` が上書きされた場合は、Gitで元に戻してください: `git checkout pubspec.yaml`

### 4. 依存パッケージのインストール

```bash
fvm flutter pub get
```

### 5. コード生成

freezed, json_serializable, isar のコード生成を実行:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### 6. 実行

```bash
# iOSシミュレータで実行
fvm flutter run -d ios

# Androidエミュレータで実行
fvm flutter run -d android

# デバイスを指定しない場合（接続されているデバイスから選択）
fvm flutter run
```

## 開発

### コード生成

モデルやプロバイダーを変更した場合は、コード生成を実行:

```bash
# 通常のコード生成
fvm dart run build_runner build --delete-conflicting-outputs

# ウォッチモード（ファイル変更時に自動生成）
fvm dart run build_runner watch --delete-conflicting-outputs
```

### テスト実行

```bash
# ユニットテストとウィジェットテスト
fvm flutter test

# カバレッジ付き
fvm flutter test --coverage

# 統合テスト
fvm flutter test integration_test
```

### Lint実行

```bash
fvm flutter analyze
```

### ビルド

```bash
# Android APK
fvm flutter build apk --release

# Android App Bundle
fvm flutter build appbundle --release

# iOS（Mac環境のみ）
fvm flutter build ios --release
```

## プロジェクト構造

```
lib/
├── main.dart                    # アプリエントリーポイント
├── app.dart                     # MaterialApp設定
├── core/                        # 共通コア機能
│   ├── router/                  # ルーティング設定
│   ├── theme/                   # テーマ設定
│   ├── constants/               # 定数
│   ├── utils/                   # ユーティリティ
│   └── widgets/                 # 共通ウィジェット
└── features/                    # 機能モジュール（feature-first）
    ├── habit/                   # 習慣機能
    ├── reward/                  # ご褒美機能
    ├── wallet/                  # ポイント管理
    ├── history/                 # 履歴
    ├── notification/            # 通知
    ├── settings/                # 設定
    ├── monetization/            # 収益化
    └── home/                    # ホーム画面
```

詳細なアーキテクチャは [DESIGN.md](docs/DESIGN.md) を参照してください。

## トラブルシューティング

### FVMが見つからない

```bash
# FVMをグローバルにインストール
dart pub global activate fvm

# PATHを追加（必要に応じて）
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### build_runnerでエラーが出る

```bash
# 古い生成ファイルを削除
fvm flutter clean
find . -name "*.g.dart" -type f -delete
find . -name "*.freezed.dart" -type f -delete

# 再度コード生成
fvm dart run build_runner build --delete-conflicting-outputs
```

### パッケージの依存関係エラー

```bash
# pub cacheをクリア
fvm flutter pub cache clean

# 再インストール
fvm flutter pub get
```

## ライセンス

This project is private and proprietary.

## 関連ドキュメント

- [DESIGN.md](docs/DESIGN.md) - 詳細な設計ドキュメント
- [TODO.md](docs/TODO.md) - タスク一覧

## 開発ステータス

**現在のフェーズ**: Phase 0 - プロジェクト初期化

進捗状況は [TODO.md](docs/TODO.md) を参照してください。
