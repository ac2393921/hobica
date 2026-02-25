import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/database/encryption_key_service.dart';

/// [AppDatabase] 生成関数の型定義。
typedef DatabaseFactory = AppDatabase Function();

/// データベースの初期化・ライフサイクル管理を担うサービス。
///
/// [EncryptionKeyService] で暗号化キーを確保した上で [AppDatabase] を生成する。
/// 将来 SQLCipher を導入する際は、取得したキーを [AppDatabase] の接続に渡す。
class DatabaseService {
  DatabaseService(
    EncryptionKeyService encryptionKeyService,
    DatabaseFactory databaseFactory,
  )   : _encryptionKeyService = encryptionKeyService,
        _databaseFactory = databaseFactory;

  final EncryptionKeyService _encryptionKeyService;
  final DatabaseFactory _databaseFactory;
  AppDatabase? _database;
  bool _isInitialized = false;

  /// 初期化済みかどうか。
  bool get isInitialized => _isInitialized;

  /// データベースを初期化する。暗号化キーの確保 → DB インスタンス生成。
  ///
  /// 二重初期化は [StateError] をスローする。
  Future<AppDatabase> initialize() async {
    if (_isInitialized) {
      throw StateError('DatabaseService is already initialized');
    }

    // 暗号化キーを確保（将来 SQLCipher 導入時に使用）
    await _encryptionKeyService.getOrCreateKey();

    final database = _databaseFactory();
    _database = database;
    _isInitialized = true;
    return database;
  }

  /// 初期化済みの [AppDatabase] を返す。
  ///
  /// 未初期化の場合は [StateError] をスローする。
  AppDatabase get database {
    if (!_isInitialized || _database == null) {
      throw StateError(
        'DatabaseService is not initialized. Call initialize() first.',
      );
    }
    return _database!;
  }

  /// データベースを閉じてリソースを解放する。
  Future<void> dispose() async {
    if (_isInitialized && _database != null) {
      await _database!.close();
      _database = null;
      _isInitialized = false;
    }
  }
}
