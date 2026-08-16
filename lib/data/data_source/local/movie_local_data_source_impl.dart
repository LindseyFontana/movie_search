import 'dart:async';

import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/data/data_source/local/trending_movies_cache.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  MovieLocalDataSourceImpl({required this.cache});

  final TrendingMoviesCache cache;

  final StreamController<PaginatedMovies> _updatesController =
      StreamController<PaginatedMovies>.broadcast();

  @override
  Stream<PaginatedMovies> get updates => _updatesController.stream;

  @override
  PaginatedMovies? get(int page) => cache.get(page);

  @override
  bool isFresh(int page) => cache.isFresh(page);

  @override
  void put(PaginatedMovies paginatedMovies) {
    cache.put(paginatedMovies);

    if (_updatesController.hasListener) {
      _updatesController.add(paginatedMovies);
    }
  }
}
