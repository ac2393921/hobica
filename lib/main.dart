import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/app.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/database/providers/database_provider.dart';
import 'package:hobica/mocks/mock_overrides.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(AppDatabase()),
        ...mockRepositoryOverrides,
      ],
      child: const HobicaApp(),
    ),
  );
}
