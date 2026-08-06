import 'package:movie_search/domain/entities/pagineted_movies.dart';

abstract class MoviesRepository {
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch);
  Future<PaginetedMovies> searchMovies({
    required String query,
    required int pageToSearch,
  });
}
