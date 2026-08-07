import 'package:movie_search/domain/entities/paginated_movies.dart';

abstract class MoviesRepository {
  Future<PaginatedMovies> getTrendingMovies(int pageToSearch);
  Future<PaginatedMovies> searchMovies({
    required String query,
    required int pageToSearch,
  });
}
