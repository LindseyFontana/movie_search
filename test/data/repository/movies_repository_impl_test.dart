import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/data/repository/movies_repository_impl.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

import '../../mocks.dart';

void main() {
  late MockMovieDataSource dataSource;
  late MoviesRepositoryImpl repository;

  const page = 5;
  const totalPage = 10;

  const paginatedMovies = PaginatedMovies(
    page: page,
    totalPages: totalPage,
    movies: [Movie(id: 1, title: 'Movie One', overview: 'Overview one')],
  );

  setUp(() {
    dataSource = MockMovieDataSource();
    repository = MoviesRepositoryImpl(dataSource);
  });

  group('getTrendingMovies', () {
    test('getTrendingMovies: should return right data', () async {
      when(
        () => dataSource.getTrendingMovies(page),
      ).thenAnswer((_) async => paginatedMovies);

      final result = await repository.getTrendingMovies(page);

      verify(() => dataSource.getTrendingMovies(page)).called(1);

      expect(result, paginatedMovies);
    });
  });

  group('searchMovies', () {
    const query = 'query';

    test('searchMovies: should return right data', () async {
      when(
        () => dataSource.searchMovies(query, page),
      ).thenAnswer((_) async => paginatedMovies);

      final result = await repository.searchMovies(
        query: query,
        pageToSearch: page,
      );

      verify(() => dataSource.searchMovies(query, page)).called(1);

      expect(result, paginatedMovies);
    });
  });
}
