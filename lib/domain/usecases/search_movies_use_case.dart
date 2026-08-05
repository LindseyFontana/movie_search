import 'package:movie_search/domain/entities/search_params.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/use_case.dart';

class SearchMoviesUseCase extends UseCase<PaginetedMovies, SearchParams> {
  SearchMoviesUseCase(MoviesRepository repository)
    : super(
        request: (params) => repository.searchMovies(
          query: params.query,
          pageToSearch: params.pageToSearch,
        ),
      );
}
