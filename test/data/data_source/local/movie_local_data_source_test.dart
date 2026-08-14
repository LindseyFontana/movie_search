import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/local/movie_local_data_source_impl.dart';
import 'package:movie_search/data/data_source/local/trending_movies_cache.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

void main() {
  const paginatedMovies = PaginatedMovies(
    page: 1,
    totalPages: 3,
    movies: [Movie(id: 1, title: 'Movie One', overview: 'Overview one')],
  );

  group('MovieLocalDataSourceImpl', () {
    test('returns null and is not fresh when nothing is cached', () {
      final dataSource = MovieLocalDataSourceImpl();

      expect(dataSource.get(1), isNull);
      expect(dataSource.isFresh(1), isFalse);
    });

    test('returns cached data and considers it fresh while within TTL', () {
      final dataSource = MovieLocalDataSourceImpl();

      dataSource.put(1, paginatedMovies);

      expect(dataSource.get(1), paginatedMovies);
      expect(dataSource.isFresh(1), isTrue);
    });

    test('keeps stale data but stops considering it fresh after TTL', () async {
      final dataSource = MovieLocalDataSourceImpl(
        cache: TrendingMoviesCache(
          timeToLive: const Duration(milliseconds: 50),
        ),
      );

      dataSource.put(1, paginatedMovies);
      expect(dataSource.isFresh(1), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(dataSource.isFresh(1), isFalse);
      expect(dataSource.get(1), paginatedMovies);
    });

    test('emits on updates stream when putting data', () async {
      final dataSource = MovieLocalDataSourceImpl();
      final updates = <PaginatedMovies>[];
      final subscription = dataSource.updates.listen(updates.add);

      dataSource.put(1, paginatedMovies);
      await Future<void>.delayed(Duration.zero);

      expect(updates, [paginatedMovies]);

      await subscription.cancel();
    });
  });
}
