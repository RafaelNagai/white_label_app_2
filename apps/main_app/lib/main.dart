import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:main_app/core/app/app_bootstrap.dart';
import 'package:main_app/core/theme/theme_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bootFirstSetup = await ThemeHandler.buildTheme();

  runApp(
    ProviderScope(child: AppBootstrap(themeConfiguration: bootFirstSetup)),
  );
}
