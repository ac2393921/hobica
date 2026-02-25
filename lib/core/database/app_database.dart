import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('HabitRow')
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  IntColumn get points => integer()();
  TextColumn get frequencyType => text()();
  IntColumn get frequencyValue => integer()();
  DateTimeColumn get remindTime => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('HabitLogRow')
class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get points => integer()();
  DateTimeColumn get createdAt => dateTime()();

  // 1日1回の完了制限: habitIdとdateの組み合わせは一意でなければならない
  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, date},
      ];
}

@DataClassName('RewardRow')
class Rewards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  TextColumn get imageUri => text().nullable()();
  IntColumn get targetPoints => integer()();
  TextColumn get category => text().nullable()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('RewardRedemptionRow')
class RewardRedemptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get rewardId => integer().references(Rewards, #id)();
  IntColumn get pointsSpent => integer()();
  DateTimeColumn get redeemedAt => dateTime()();
}

@DataClassName('WalletRow')
class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentPoints => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('AppSettingsRow')
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get locale => text().withDefault(const Constant('ja'))();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('PremiumStatusRow')
class PremiumStatuses extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  DateTimeColumn get premiumExpiresAt => dateTime().nullable()();
  TextColumn get purchaseToken => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
}

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

  AppDatabase.forTesting(super.executor);

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
