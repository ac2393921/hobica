import 'package:hobica/core/database/encryption_key_service.dart';

/// テスト用の [EncryptionKeyService] フェイク実装。
///
/// インメモリでキーを管理する。FlutterSecureStorage への依存なし。
class FakeEncryptionKeyService implements EncryptionKeyService {
  /// [fixedKey] は [getOrCreateKey] で新規生成時に返す固定キー。
  FakeEncryptionKeyService(String fixedKey) : _fixedKey = fixedKey;

  String? _storedKey;
  final String _fixedKey;

  @override
  Future<String> getOrCreateKey() async {
    if (_storedKey != null) {
      return _storedKey!;
    }
    _storedKey = _fixedKey;
    return _fixedKey;
  }

  @override
  Future<void> deleteKey() async {
    _storedKey = null;
  }
}
