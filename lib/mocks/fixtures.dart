import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';

class HabitFixtures {
  HabitFixtures._();

  static List<Habit> initialHabits() => [
        Habit(
          id: 1,
          title: '読書 30分',
          points: 30,
          frequencyType: FrequencyType.daily,
          frequencyValue: 1,
          createdAt: DateTime(2026, 2, 1),
        ),
        Habit(
          id: 2,
          title: 'ランニング',
          points: 50,
          frequencyType: FrequencyType.weekly,
          frequencyValue: 3,
          createdAt: DateTime(2026, 2, 1),
        ),
      ];
}
