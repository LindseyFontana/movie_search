import 'package:movie_search/data/data_source/remote/movie_data_source.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MovieDataSource _datasource;

  const MoviesRepositoryImpl(this._datasource);

  @override
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch) =>
      _datasource.getTrendingMovies(pageToSearch);

  @override
  Future<PaginetedMovies> searchMovies({
    required String query,
    required int pageToSearch,
  }) => _datasource.searchMovies(query, pageToSearch);
}
