import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_encryption_key_service.dart';

void main() {
  group('FakeEncryptionKeyService', () {
    const testKey = 'dGVzdC1lbmNyeXB0aW9uLWtleS0xMjM0NTY3ODkwYWI=';

    group('getOrCreateKey', () {
      test('初回呼び出しでキーを生成して返す', () async {
        final service = FakeEncryptionKeyService(testKey);

        final key = await service.getOrCreateKey();

        expect(key, testKey);
      });

      test('2回目以降は同じキーを返す', () async {
        final service = FakeEncryptionKeyService(testKey);

        final firstKey = await service.getOrCreateKey();
        final secondKey = await service.getOrCreateKey();

        expect(firstKey, secondKey);
      });
    });

    group('deleteKey', () {
      test('キー削除後に getOrCreateKey で再生成できる', () async {
        final service = FakeEncryptionKeyService(testKey);
        await service.getOrCreateKey();
        await service.deleteKey();

        final newKey = await service.getOrCreateKey();

        expect(newKey, testKey);
      });
    });
  });
}
