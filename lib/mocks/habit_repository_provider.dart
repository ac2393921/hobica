import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/features/habit/domain/repositories/habit_repository.dart';
import 'package:hobica/mocks/mock_habit_repository.dart';

final habitRepositoryProvider = Provider<HabitRepository>(
  (_) => MockHabitRepository(),
);
