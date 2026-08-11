import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_sizes.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(centerTitle: true),
  iconTheme: IconThemeData(color: const Color.fromRGBO(161, 45, 36, 1)),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1E1E1E),
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(148, 255, 255, 255),
      foregroundColor: Colors.black,
    ),
  ),
);
