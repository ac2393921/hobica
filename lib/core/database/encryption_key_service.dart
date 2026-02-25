import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 暗号化キーの生成・保存・取得を担うインターフェース。
///
/// 将来の SQLCipher 統合時にデータベース暗号化キーとして使用する。
abstract interface class EncryptionKeyService {
  /// 暗号化キーを取得する。未生成の場合は新規に生成して永続化する。
  Future<String> getOrCreateKey();

  /// 保存されている暗号化キーを削除する。
  Future<void> deleteKey();
}

const String _kEncryptionKeyStorageKey = 'db_encryption_key';
const int _kEncryptionKeyLength = 32;

/// [FlutterSecureStorage] を使った [EncryptionKeyService] 実装。
///
/// キーは Base64 エンコードされた 32 バイトのランダムデータ。
class SecureStorageEncryptionKeyService implements EncryptionKeyService {
  SecureStorageEncryptionKeyService(
    FlutterSecureStorage storage,
    Random random,
  )   : _storage = storage,
        _random = random;

  final FlutterSecureStorage _storage;
  final Random _random;

  @override
  Future<String> getOrCreateKey() async {
    final existingKey = await _storage.read(key: _kEncryptionKeyStorageKey);
    if (existingKey != null) {
      return existingKey;
    }

    final key = _generateKey();
    await _storage.write(key: _kEncryptionKeyStorageKey, value: key);
    return key;
  }

  @override
  Future<void> deleteKey() async {
    await _storage.delete(key: _kEncryptionKeyStorageKey);
  }

  String _generateKey() {
    final bytes = Uint8List.fromList(
      List.generate(_kEncryptionKeyLength, (_) => _random.nextInt(256)),
    );
    return base64Encode(bytes);
  }
}
