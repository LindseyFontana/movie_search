import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/use_case.dart';

class GetTrendingMoviesUseCase extends UseCase<PaginatedMovies, int> {
  GetTrendingMoviesUseCase(MoviesRepository repository)
    : _repository = repository,
      super(
        request: (pageToSearch) => repository.getTrendingMovies(pageToSearch),
      );

  final MoviesRepository _repository;

  Stream<PaginatedMovies> get trendingUpdates => _repository.trendingUpdates;
}
