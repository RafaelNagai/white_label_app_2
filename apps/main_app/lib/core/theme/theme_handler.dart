import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:main_app/core/theme/theme_configuration.dart';

class ThemeHandler {
  static final baseTheme = ThemeData();

  static Future<ThemeConfiguration> buildTheme() async {
    final raw = await rootBundle.loadString(
      'configuration/configuration_app.json',
    );
    final json = jsonDecode(raw);

    return ThemeConfiguration(
      light: baseTheme.copyWith(
        brightness: Brightness.light,
        primaryColor: _colorFromHex(json['theme']['light']['primary']),
      ),
      dark: baseTheme.copyWith(
        brightness: Brightness.dark,
        primaryColor: _colorFromHex(json['theme']['dark']['primary']),
      ),
    );
  }

  static Color _colorFromHex(String hex) =>
      Color(0xFF000000 | int.parse(hex, radix: 16));
}
