import 'package:flutter/material.dart';
import '../state/role_provider.dart';
import 'role_colours.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData light(UserRole role) {
    final color = RoleColors.primary(role);

    final scheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: buildTextTheme(scheme),
      scaffoldBackgroundColor: scheme.surface,
    );
  }

  static ThemeData dark(UserRole role) {
    final color = RoleColors.primary(role);

    final scheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.dark,
    );

    const darkBackground = Color(0xFF0F172A);
    const darkSurface    = Color(0xFF1E293B);


    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: darkSurface,
      ),
      textTheme: buildTextTheme(scheme),
      scaffoldBackgroundColor: darkBackground,
    );
  }
}
