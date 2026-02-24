import 'package:hobica/core/router/router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class HobicaApp extends StatelessWidget {
  const HobicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp.router(
      title: 'Hobica',
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorSchemes.slate(ThemeMode.light),
        radius: 0.5,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorSchemes.slate(ThemeMode.dark),
        radius: 0.5,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
