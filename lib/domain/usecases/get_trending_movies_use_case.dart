import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/use_case.dart';

class GetTrendingMoviesUseCase extends UseCase<PaginetedMovies, int> {
  GetTrendingMoviesUseCase(MoviesRepository repository)
    : super(
        request: (pageToSearch) => repository.getTrendingMovies(pageToSearch),
      );
}
