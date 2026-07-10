import 'package:flutter/material.dart';

class BaseThemeExtension extends ThemeExtension<BaseThemeExtension> {
  final Color red;

  BaseThemeExtension({required this.red});

  @override
  BaseThemeExtension copyWith({Color? red, Color? darkRed}) {
    return BaseThemeExtension(red: red ?? this.red);
  }

  @override
  BaseThemeExtension lerp(covariant BaseThemeExtension? other, double t) {
    if (other == null) return this;

    return BaseThemeExtension(red: Color.lerp(red, other.red, t)!);
  }
}
