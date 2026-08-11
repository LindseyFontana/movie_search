import 'package:movie_search/domain/entities/paginated_movies.dart';

abstract class MovieDataSource {
  Future<PaginatedMovies> getTrendingMovies(int pageToSearch);

  Future<PaginatedMovies> searchMovies(String query, int pageToSearch);
}
