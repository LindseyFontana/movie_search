import 'package:movie_search/domain/entities/trending_movies.dart';

abstract class MoviesRepository {
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch);
}
