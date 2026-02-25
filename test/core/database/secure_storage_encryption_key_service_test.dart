import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/encryption_key_service.dart';

/// テスト用の [FlutterSecureStorage] フェイク。インメモリで key-value を保持する。
class _FakeFlutterSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.remove(key);
  }
}

void main() {
  group('SecureStorageEncryptionKeyService', () {
    late _FakeFlutterSecureStorage fakeStorage;

    setUp(() {
      fakeStorage = _FakeFlutterSecureStorage();
    });

    group('getOrCreateKey', () {
      test('生成されたキーは有効な Base64 文字列である', () async {
        final service = SecureStorageEncryptionKeyService(
          fakeStorage,
          Random(42),
        );

        final key = await service.getOrCreateKey();

        expect(() => base64Decode(key), returnsNormally);
      });

      test('生成されたキーをデコードすると 32 バイトになる', () async {
        final service = SecureStorageEncryptionKeyService(
          fakeStorage,
          Random(42),
        );

        final key = await service.getOrCreateKey();
        final decoded = base64Decode(key);

        expect(decoded.length, 32);
      });

      test('2回目の呼び出しは同じキーを返す', () async {
        final service = SecureStorageEncryptionKeyService(
          fakeStorage,
          Random(42),
        );

        final firstKey = await service.getOrCreateKey();
        final secondKey = await service.getOrCreateKey();

        expect(firstKey, secondKey);
      });

      test('異なる Random シードで異なるキーが生成される', () async {
        final storage1 = _FakeFlutterSecureStorage();
        final storage2 = _FakeFlutterSecureStorage();
        final service1 = SecureStorageEncryptionKeyService(
          storage1,
          Random(1),
        );
        final service2 = SecureStorageEncryptionKeyService(
          storage2,
          Random(2),
        );

        final key1 = await service1.getOrCreateKey();
        final key2 = await service2.getOrCreateKey();

        expect(key1, isNot(key2));
      });
    });

    group('deleteKey', () {
      test('キー削除後に getOrCreateKey で新しいキーが生成される', () async {
        final service = SecureStorageEncryptionKeyService(
          fakeStorage,
          Random(42),
        );

        final firstKey = await service.getOrCreateKey();
        await service.deleteKey();
        final secondKey = await service.getOrCreateKey();

        expect(base64Decode(secondKey).length, 32);
        expect(secondKey, isNot(firstKey));
      });
    });
  });
}
