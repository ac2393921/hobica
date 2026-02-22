import 'package:flutter_test/flutter_test.dart';
import 'package:hobica/core/errors/app_error.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/domain/models/habit_log.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';

class _FakeHabitRepository implements HabitRepository {
  // 1日1回制限のエラーパスをテストするために当日完了済み習慣IDを追跡する
  final Set<int> _completedToday = {};

  @override
  Future<List<Habit>> fetchAllHabits() async => const [];

  @override
  Future<Habit?> fetchHabitById(int id) async => null;

  @override
  Future<Habit> createHabit({
    required String title,
    required int points,
    required FrequencyType frequencyType,
    required int frequencyValue,
    DateTime? remindTime,
  }) async =>
      Habit(
        id: 1,
        title: title,
        points: points,
        frequencyType: frequencyType,
        frequencyValue: frequencyValue,
        remindTime: remindTime,
        createdAt: DateTime(2026, 2, 22),
        isActive: true,
      );

  @override
  Future<Habit> updateHabit(Habit habit) async => habit;

  @override
  Future<void> deleteHabit(int id) async {}

  @override
  Future<Result<HabitLog, AppError>> completeHabit(int habitId) async {
    if (_completedToday.contains(habitId)) {
      return const Result.failure(
        AppError.alreadyCompleted('本日は既に完了済みです'),
      );
    }
    _completedToday.add(habitId);
    return Result.success(HabitLog(
      id: 1,
      habitId: habitId,
      date: DateTime(2026, 2, 22),
      points: 30,
      createdAt: DateTime(2026, 2, 22),
    ),);
  }

  @override
  Future<List<HabitLog>> fetchHabitLogs(int habitId) async => const [];

  @override
  Future<bool> isCompletedToday(int habitId) async => false;
}

void main() {
  group('HabitRepository インターフェースコントラクト', () {
    late HabitRepository repository;

    setUp(() => repository = _FakeHabitRepository());

    test('fetchAllHabits は List<Habit> を返す', () async {
      final result = await repository.fetchAllHabits();
      expect(result, isA<List<Habit>>());
    });

    test('fetchHabitById は存在しないIDで null を返す', () async {
      final result = await repository.fetchHabitById(999);
      expect(result, isNull);
    });

    test('createHabit は Habit を返す', () async {
      final result = await repository.createHabit(
        title: '読書 30分',
        points: 30,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
      );
      expect(result, isA<Habit>());
      expect(result.title, '読書 30分');
      expect(result.points, 30);
    });

    test('updateHabit は更新後の Habit を返す', () async {
      final habit = Habit(
        id: 1,
        title: '読書',
        points: 50,
        frequencyType: FrequencyType.daily,
        frequencyValue: 1,
        createdAt: DateTime(2026, 2, 22),
        isActive: true,
      );
      final result = await repository.updateHabit(habit);
      expect(result, isA<Habit>());
    });

    test('deleteHabit は例外なく完了する', () async {
      await expectLater(repository.deleteHabit(1), completes);
    });

    test('completeHabit は Result<HabitLog, AppError> を Success で返す', () async {
      final result = await repository.completeHabit(1);
      expect(result, isA<Result<HabitLog, AppError>>());
      result.when(
        success: (log) => expect(log.habitId, 1),
        failure: (_) => fail('Success を期待したが Failure が返った'),
      );
    });

    test('completeHabit は同じ habitId を 2 回呼び出すと alreadyCompleted エラーを返す',
        () async {
      await repository.completeHabit(1);
      final result = await repository.completeHabit(1);
      result.when(
        success: (_) => fail('Failure を期待したが Success が返った'),
        failure: (error) => expect(error, isA<AlreadyCompletedError>()),
      );
    });

    test('fetchHabitLogs は List<HabitLog> を返す', () async {
      final result = await repository.fetchHabitLogs(1);
      expect(result, isA<List<HabitLog>>());
    });

    test('isCompletedToday は bool を返す', () async {
      final result = await repository.isCompletedToday(1);
      expect(result, isA<bool>());
    });
  });
}
