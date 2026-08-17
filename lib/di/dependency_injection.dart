import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/data/data_source/local/movie_local_data_source_impl.dart';
import 'package:movie_search/data/data_source/local/trending_movies_cache.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source_impl.dart';
import 'package:movie_search/data/repository/movies_repository_impl.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomCacheManager {
  static const key = 'movies_app_cache_key';

  static CacheManager instance = CacheManager(
    Config(key, maxNrOfCacheObjects: 30, stalePeriod: const Duration(days: 5)),
  );
}

GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerFactory<HttpService>(() => HttpService());

  getIt.registerFactory<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt<HttpService>()),
  );

  getIt.registerFactory<TrendingMoviesCache>(
    () => TrendingMoviesCache(sharedPreferences),
  );

  getIt.registerFactory<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(cache: getIt<TrendingMoviesCache>()),
  );

  getIt.registerFactory<MoviesRepositoryImpl>(
    () => MoviesRepositoryImpl(
      getIt<MovieRemoteDataSource>(),
      getIt<MovieLocalDataSource>(),
    ),
  );

  getIt.registerFactory<GetTrendingMoviesUseCase>(
    () => GetTrendingMoviesUseCase(getIt<MoviesRepositoryImpl>()),
  );

  getIt.registerFactory<SearchMoviesUseCase>(
    () => SearchMoviesUseCase(getIt<MoviesRepositoryImpl>()),
  );

  getIt.registerFactory<MoviesSearchBloc>(
    () => MoviesSearchBloc(
      getIt<GetTrendingMoviesUseCase>(),
      getIt<SearchMoviesUseCase>(),
    ),
  );
}
