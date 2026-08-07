import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_sizes.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(centerTitle: true),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1E1E1E),
    primary: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onSurfaceVariant: Color(0xFFB3B3B3),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(fontSize: AppSizes.font.titleLarge),
    titleSmall: TextStyle(fontSize: AppSizes.font.titleSmall),
    bodyLarge: TextStyle(fontSize: AppSizes.font.bodyLarge),
    bodyMedium: TextStyle(fontSize: AppSizes.font.bodySmall),
  ),
);
