import 'package:movie_search/domain/entities/paginated_movies.dart';

abstract class MovieLocalDataSource {
  PaginatedMovies? get(int page);

  bool isFresh(int page);

  void put(PaginatedMovies paginatedMovies);

  Stream<PaginatedMovies> get updates;
}
