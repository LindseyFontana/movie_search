import 'package:movie_search/domain/entities/search_params.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/use_case.dart';

class SearchMoviesUseCase extends UseCase<PaginatedMovies, SearchParams> {
  SearchMoviesUseCase(MoviesRepository repository)
    : super(
        request: (params) => repository.searchMovies(
          query: params.query,
          pageToSearch: params.pageToSearch,
        ),
      );
}
