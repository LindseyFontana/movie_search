import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/domain/entities/search_params.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  late MockMoviesRepository repository;
  late SearchMoviesUseCase useCase;

  const searchParams = SearchParams(query: 'inception', pageToSearch: 2);

  const paginatedMovies = PaginatedMovies(page: 2, totalPages: 50, movies: []);

  setUp(() {
    repository = MockMoviesRepository();
    useCase = SearchMoviesUseCase(repository);
  });

  test('returns Right with PaginatedMovies on success', () async {
    when(
      () => repository.searchMovies(
        query: any(named: 'query'),
        pageToSearch: any(named: 'pageToSearch'),
      ),
    ).thenAnswer((_) async => paginatedMovies);

    final result = await useCase.call(searchParams);

    verify(
      () => repository.searchMovies(
        query: searchParams.query,
        pageToSearch: searchParams.pageToSearch,
      ),
    ).called(1);

    expect(result, isA<Right<Failure, PaginatedMovies>>());
    expect(result.right, paginatedMovies);
  });
}
