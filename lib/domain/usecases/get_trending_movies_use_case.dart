import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/use_case.dart';

class GetTrendingMoviesUseCase implements UseCase<TrendingMovies, void> {
  final MoviesRepository _repository;

  const GetTrendingMoviesUseCase(this._repository);

  @override
  Future<TrendingMovies> call(void params) async {
    return _repository.getTrendingMovies();
  }
}
