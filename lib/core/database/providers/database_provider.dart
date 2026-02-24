import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/core/database/app_database.dart';

/// Drift AppDatabase のプロバイダー。
///
/// main.dart の ProviderScope.overrides で AppDatabase インスタンスを注入する。
/// この Provider はデフォルトでエラーを投げ、オーバーライドが必須であることを明示する。
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in ProviderScope',
  );
});
