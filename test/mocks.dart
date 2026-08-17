import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/data/data_source/local/trending_movies_cache.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockTrendingMoviesCache extends Mock implements TrendingMoviesCache {}

class MockMovieLocalDataSource extends Mock implements MovieLocalDataSource {}

class MockHttpService extends Mock implements HttpService {}

class MockDio extends Mock implements Dio {}

class MockGetTrendingMoviesUseCase extends Mock
    implements GetTrendingMoviesUseCase {}

class MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}

class MockMoviesSearchBloc extends Mock implements MoviesSearchBloc {}

class MockCacheManager extends Mock implements CacheManager {
  Stream<FileResponse> Function() getFileStreamOverride = () =>
      const Stream<FileResponse>.empty();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
  }) {
    return getFileStreamOverride();
  }
}
