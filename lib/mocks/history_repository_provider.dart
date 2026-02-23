import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/features/history/domain/repositories/history_repository.dart';
import 'package:hobica/mocks/mock_history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (_) => MockHistoryRepository(),
);
