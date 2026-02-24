import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/app.dart';
import 'package:hobica/core/database/app_database.dart';
import 'package:hobica/core/database/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const HobicaApp(),
    ),
  );
}
