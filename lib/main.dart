import 'package:flutter/material.dart';
import 'package:movie_search/core/theme.dart';
import 'package:movie_search/di/dependecy_injection.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/screens/credits/credits_screen.dart';
import 'package:movie_search/presentation/screens/movie_details/movie_details_screen.dart';
import 'package:movie_search/presentation/screens/movies_search/movies_search_screen.dart';

void main() {
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: dartTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => MoviesSearchScreen(),
        '/credits': (context) => CreditsScreen(),
        '/movie_details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Movie;

          return MovieDetailsScreen(args);
        },
      },
    );
  }
}
