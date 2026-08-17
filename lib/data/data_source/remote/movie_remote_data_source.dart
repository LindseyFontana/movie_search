import 'package:movie_search/domain/entities/paginated_movies.dart';

abstract class MovieRemoteDataSource {
  Future<PaginatedMovies> getTrendingMovies(int pageToSearch);

  Future<PaginatedMovies> searchMovies(String query, int pageToSearch);
}
