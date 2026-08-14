import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/data/repository/movies_repository_impl.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

import '../../mocks.dart';

void main() {
  late MockMovieDataSource dataSource;
  late MockMovieLocalDataSource localDataSource;
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
    localDataSource = MockMovieLocalDataSource();
    repository = MoviesRepositoryImpl(dataSource, localDataSource);
  });

  group('getTrendingMovies', () {
    test('getTrendingMovies: should return right data', () async {
      when(() => localDataSource.get(page)).thenReturn(null);
      when(
        () => dataSource.getTrendingMovies(page),
      ).thenAnswer((_) async => paginatedMovies);

      final result = await repository.getTrendingMovies(page);

      verify(() => dataSource.getTrendingMovies(page)).called(1);
      verify(() => localDataSource.put(page, paginatedMovies)).called(1);

      expect(result, paginatedMovies);
    });

    test('serves cached data without hitting remote while fresh', () async {
      when(() => localDataSource.get(page)).thenReturn(paginatedMovies);
      when(() => localDataSource.isFresh(page)).thenReturn(true);

      final result = await repository.getTrendingMovies(page);

      verifyNever(() => dataSource.getTrendingMovies(page));

      expect(result, paginatedMovies);
    });

    test('serves stale cache and revalidates in background', () async {
      when(() => localDataSource.get(page)).thenReturn(paginatedMovies);
      when(() => localDataSource.isFresh(page)).thenReturn(false);
      when(
        () => dataSource.getTrendingMovies(page),
      ).thenAnswer((_) async => paginatedMovies);

      final result = await repository.getTrendingMovies(page);
      await Future<void>.delayed(Duration.zero);

      verify(() => dataSource.getTrendingMovies(page)).called(1);
      verify(() => localDataSource.put(page, paginatedMovies)).called(1);

      expect(result, paginatedMovies);
    });

    test('forwards local datasource updates stream', () {
      final stream = Stream<PaginatedMovies>.empty();
      when(() => localDataSource.updates).thenAnswer((_) => stream);

      expect(repository.trendingUpdates, same(stream));
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
