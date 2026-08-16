import 'dart:async';

import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/data/data_source/remote/movie_data_source.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  const MoviesRepositoryImpl(this._remote, this._local);

  final MovieDataSource _remote;
  final MovieLocalDataSource _local;

  @override
  Stream<PaginatedMovies> get trendingUpdates => _local.updates;

  @override
  Future<PaginatedMovies> getTrendingMovies(int pageToSearch) async {
    final cached = _local.get(pageToSearch);

    if (cached != null) {
      if (!_local.isFresh(pageToSearch)) {
        unawaited(_revalidateTrending(pageToSearch));
      }

      return cached;
    }

    final fresh = await _remote.getTrendingMovies(pageToSearch);

    _local.put(fresh);

    return fresh;
  }

  Future<void> _revalidateTrending(int pageToSearch) async {
    try {
      final fresh = await _remote.getTrendingMovies(pageToSearch);

      _local.put(fresh);
    } catch (_) {
      //It silently fails when trying to update trending movies, and keeps the user's data out of date.
    }
  }

  @override
  Future<PaginatedMovies> searchMovies({
    required String query,
    required int pageToSearch,
  }) => _remote.searchMovies(query, pageToSearch);
}
