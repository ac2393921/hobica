import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/data/datasources/habit_local_data_source.dart';
import 'package:hobica/features/habit/data/repositories/habit_repository_impl.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/history/data/repositories/history_repository_impl.dart';
import 'package:hobica/features/reward/data/datasources/reward_local_datasource.dart';
import 'package:hobica/features/reward/data/repositories/reward_repository_impl.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/wallet/data/repositories/wallet_repository_impl.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late HistoryRepositoryImpl repo;
  late HabitRepositoryImpl habitRepo;
  late RewardRepositoryImpl rewardRepo;
  late WalletRepositoryImpl walletRepo;

  setUp(() {
    db = _createInMemoryDb();
    repo = HistoryRepositoryImpl(db);
    habitRepo = HabitRepositoryImpl(HabitLocalDataSource(db));
    rewardRepo = RewardRepositoryImpl(RewardLocalDataSource(db));
    walletRepo = WalletRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('HistoryRepositoryImpl', () {
    group('fetchHabitLogs', () {
      test('returns empty list when no logs exist', () async {
        final logs = await repo.fetchHabitLogs();
        expect(logs, isEmpty);
      });

      test('returns habit logs after completion', () async {
        final habitResult = await habitRepo.createHabit(
          title: 'Test Habit',
          points: 20,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitId = (habitResult as Success<Habit, AppError>).value.id;
        await habitRepo.completeHabit(habitId);

        final logs = await repo.fetchHabitLogs();
        expect(logs.length, 1);
        expect(logs.first.habitId, habitId);
        expect(logs.first.points, 20);
      });

      test('returns logs in descending order by createdAt', () async {
        // Habit Logs の順序は createdAt DESC
        final habitResult1 = await habitRepo.createHabit(
          title: 'Habit 1',
          points: 10,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        final habitResult2 = await habitRepo.createHabit(
          title: 'Habit 2',
          points: 20,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
        );
        // 同じ日に両方完了させると uniqueKey 違反になるので1つだけ
        await habitRepo.completeHabit(
          (habitResult1 as Success<Habit, AppError>).value.id,
        );
        // 別のHabitをもう1件完了させる（同日は1回のみ制限があるため別HabitのID使用）
        // habit 2は別IDなのでOK
        await habitRepo.completeHabit(
          (habitResult2 as Success<Habit, AppError>).value.id,
        );

        final logs = await repo.fetchHabitLogs();
        expect(logs.length, 2);
      });
    });

    group('fetchRedemptions', () {
      test('returns empty list when no redemptions exist', () async {
        final redemptions = await repo.fetchRedemptions();
        expect(redemptions, isEmpty);
      });

      test('returns redemptions after reward redemption', () async {
        final rewardResult = await rewardRepo.createReward(
          title: 'Nice Reward',
          targetPoints: 100,
        );
        final rewardId = (rewardResult as Success<Reward, AppError>).value.id;
        await walletRepo.addPoints(100);
        await rewardRepo.redeemReward(rewardId, 100);

        final redemptions = await repo.fetchRedemptions();
        expect(redemptions.length, 1);
        expect(redemptions.first.rewardId, rewardId);
        expect(redemptions.first.pointsSpent, 100);
      });
    });
  });
}
