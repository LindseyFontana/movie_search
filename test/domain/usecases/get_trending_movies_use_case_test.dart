import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  late MockMoviesRepository repository;
  late GetTrendingMoviesUseCase useCase;

  const pageToSearch = 2;

  const paginatedMovies = PaginatedMovies(
    page: 2,
    totalPages: 50,
    movies: [],
  );

  setUp(() {
    repository = MockMoviesRepository();
    useCase = GetTrendingMoviesUseCase(repository);
  });

  test('returns Right with PaginatedMovies on success', () async {
    when(() => repository.getTrendingMovies(pageToSearch)).thenAnswer(
      (_) async => paginatedMovies,
    );

    final result = await useCase.call(pageToSearch);

    verify(() => repository.getTrendingMovies(pageToSearch)).called(1);
    expect(result, isA<Right<Failure, PaginatedMovies>>());
    expect(result.right, paginatedMovies);
  });
}
