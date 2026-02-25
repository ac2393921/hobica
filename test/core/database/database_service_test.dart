import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/database/database_service.dart';

import '../../helpers/fake_encryption_key_service.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  const testKey = 'dGVzdC1lbmNyeXB0aW9uLWtleS0xMjM0NTY3ODkwYWI=';

  late FakeEncryptionKeyService fakeKeyService;
  late DatabaseService databaseService;

  setUp(() {
    fakeKeyService = FakeEncryptionKeyService(testKey);
    databaseService = DatabaseService(fakeKeyService, _createInMemoryDb);
  });

  tearDown(() async {
    await databaseService.dispose();
  });

  group('DatabaseService', () {
    group('initialize', () {
      test('初期化前は isInitialized が false', () {
        expect(databaseService.isInitialized, isFalse);
      });

      test('初期化すると AppDatabase を返す', () async {
        final db = await databaseService.initialize();

        expect(db, isA<AppDatabase>());
        expect(databaseService.isInitialized, isTrue);
      });

      test('初期化時に暗号化キーを確保する', () async {
        await databaseService.initialize();

        final key = await fakeKeyService.getOrCreateKey();
        expect(key, isNotEmpty);
      });

      test('二重初期化は StateError をスローする', () async {
        await databaseService.initialize();

        expect(
          () => databaseService.initialize(),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('database getter', () {
      test('初期化前のアクセスは StateError をスローする', () {
        expect(
          () => databaseService.database,
          throwsA(isA<StateError>()),
        );
      });

      test('初期化後は AppDatabase を返す', () async {
        final db = await databaseService.initialize();

        expect(databaseService.database, same(db));
      });
    });

    group('dispose', () {
      test('dispose 後は isInitialized が false になる', () async {
        await databaseService.initialize();

        await databaseService.dispose();

        expect(databaseService.isInitialized, isFalse);
      });

      test('dispose 後の database アクセスは StateError', () async {
        await databaseService.initialize();

        await databaseService.dispose();

        expect(
          () => databaseService.database,
          throwsA(isA<StateError>()),
        );
      });

      test('未初期化状態での dispose は安全に完了する', () async {
        await databaseService.dispose();

        expect(databaseService.isInitialized, isFalse);
      });
    });
  });
}
