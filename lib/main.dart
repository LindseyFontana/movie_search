import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_search/core/theme.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/data_source/remote/movie_data_source.dart';
import 'package:movie_search/data/repository/movies_repository_impl.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';
import 'package:movie_search/presentation/screens/movies_search/movies_search_screen.dart';

import 'domain/usecases/get_trending_movies_use_case.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerFactory<HttpService>(() => HttpService());

  getIt.registerFactory<MovieDataSource>(
    () => MovieDataSourceImpl(getIt<HttpService>()),
  );

  getIt.registerFactory<MoviesRepositoryImpl>(
    () => MoviesRepositoryImpl(getIt<MovieDataSource>()),
  );

  getIt.registerFactory<GetTrendingMoviesUseCase>(
    () => GetTrendingMoviesUseCase(getIt<MoviesRepositoryImpl>()),
  );

  getIt.registerFactory<SearchMoviesUseCase>(
    () => SearchMoviesUseCase(getIt<MoviesRepositoryImpl>()),
  );

  getIt.registerLazySingleton<MoviesSearchBloc>(
    () => MoviesSearchBloc(
      getIt<GetTrendingMoviesUseCase>(),
      getIt<SearchMoviesUseCase>(),
    ),
  );
}

void main() {
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: dartTheme, home: MoviesSearchScreen());
  }
}
