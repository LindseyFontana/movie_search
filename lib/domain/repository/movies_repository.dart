import 'package:movie_search/domain/entities/trending_movies.dart';

abstract class MoviesRepository {
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch);
  Future<PaginetedMovies> searchMovies({
    required String query,
    required int pageToSearch,
  });
}
