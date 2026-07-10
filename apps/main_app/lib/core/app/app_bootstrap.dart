import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:main_app/core/routes/route_handler.dart';
import 'package:main_app/core/theme/theme_configuration.dart';
import 'package:main_app/features/load_setup/presentation/load_setup_page.dart';
import 'package:main_app/features/load_setup/presentation/providers/setup_configuration_provider.dart';

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({super.key, required this.themeConfiguration});

  final ThemeConfiguration themeConfiguration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSetup = ref.watch(loadSetupConfigurationProvider);

    if (asyncSetup.value == null) {
      return MaterialApp(
        theme: themeConfiguration.light,
        darkTheme: themeConfiguration.dark,
        home: const LoadSetupPage(),
      );
    }

    return MaterialApp.router(
      routerConfig: RouteHandler.routes,
      theme: themeConfiguration.light,
      darkTheme: themeConfiguration.dark,
    );
  }
}
