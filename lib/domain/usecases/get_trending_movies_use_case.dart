import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/use_case.dart';

class GetTrendingMoviesUseCase extends UseCase<TrendingMovies, void> {
  GetTrendingMoviesUseCase(MoviesRepository repository)
    : super(request: (_) => repository.getTrendingMovies());
}
