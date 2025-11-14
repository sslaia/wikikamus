import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  /// Base TextTheme.
  static TextTheme _buildTextTheme(TextTheme base, double fontScale) {
    final double defaultFontSize = base.bodyMedium?.fontSize ?? 14.0;

    double? scale(double? size) => (size ?? defaultFontSize) * fontScale;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontSize: scale(base.displayLarge?.fontSize)),
      displayMedium: base.displayMedium?.copyWith(fontSize: scale(base.displayMedium?.fontSize)),
      displaySmall: base.displaySmall?.copyWith(fontSize: scale(base.displaySmall?.fontSize)),
      headlineLarge: base.headlineLarge?.copyWith(fontSize: scale(base.headlineLarge?.fontSize)),
      headlineMedium: base.headlineMedium?.copyWith(fontSize: scale(base.headlineMedium?.fontSize)),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: scale(base.headlineSmall?.fontSize)),
      titleLarge: base.titleLarge?.copyWith(fontSize: scale(base.titleLarge?.fontSize)),
      titleMedium: base.titleMedium?.copyWith(fontSize: scale(base.titleMedium?.fontSize)),
      titleSmall: base.titleSmall?.copyWith(fontSize: scale(base.titleSmall?.fontSize)),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: scale(base.bodyLarge?.fontSize)),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: scale(base.bodyMedium?.fontSize)),
      bodySmall: base.bodySmall?.copyWith(fontSize: scale(base.bodySmall?.fontSize)),
      labelLarge: base.labelLarge?.copyWith(fontSize: scale(base.labelLarge?.fontSize)),
      labelMedium: base.labelMedium?.copyWith(fontSize: scale(base.labelMedium?.fontSize)),
      labelSmall: base.labelSmall?.copyWith(fontSize: scale(base.labelSmall?.fontSize)),
    );
  }

  // Light theme
  static ThemeData getLightTheme(double fontScale) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: Brightness.light,
      ),
      // appBarTheme: const AppBarTheme(
      //   backgroundColor: Colors.deepOrange,
      //   foregroundColor: Colors.white,
      // ),
    );
    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: baseTheme.colorScheme.surfaceContainer,
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme, fontScale),
    );
  }

  // Dark theme
  static ThemeData getDarkTheme(double fontScale) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      // appBarTheme: const AppBarTheme(
      //   backgroundColor: Color.fromARGB(255, 48, 20, 0),
      // ),
    );
    return baseTheme.copyWith(
      // appBarTheme: AppBarTheme(
      //   backgroundColor: baseTheme.colorScheme.surfaceContainer,
      // ),
      textTheme: _buildTextTheme(baseTheme.textTheme, fontScale),
    );
  }
}