import 'package:movie_search/domain/entities/trending_movies.dart';

abstract class MoviesRepository {
  Future<TrendingMovies> getTrendingMovies(int pageToSearch);
}
