import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobica/app.dart';
import 'package:hobica/mocks/mock_overrides.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: mockRepositoryOverrides,
      child: const HobicaApp(),
    ),
  );
}
