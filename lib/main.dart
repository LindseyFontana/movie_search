import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/theme.dart';
import 'package:movie_search/di/dependency_injection.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/screens/credits/credits_screen.dart';
import 'package:movie_search/presentation/screens/movie_details/movie_details_screen.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';
import 'package:movie_search/presentation/screens/movies_search/movies_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      initialRoute: AppStrings.routes.home,
      routes: {
        AppStrings.routes.home: (context) => BlocProvider<MoviesSearchBloc>(
          create: (_) => getIt<MoviesSearchBloc>(),
          child: MoviesSearchScreen(),
        ),
        AppStrings.routes.credits: (context) => CreditsScreen(),
        AppStrings.routes.movieDetails: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Movie;

          return MovieDetailsScreen(args);
        },
      },
    );
  }
}
