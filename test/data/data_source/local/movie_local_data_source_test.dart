import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/local/movie_local_data_source_impl.dart';
import 'package:movie_search/data/data_source/local/trending_movies_cache.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const paginatedMovies = PaginatedMovies(
    page: 1,
    totalPages: 3,
    movies: [Movie(id: 1, title: 'Movie One', overview: 'Overview one')],
  );

  late TrendingMoviesCache cache;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    cache = TrendingMoviesCache(
      sharedPreferences,
      timeToLive: const Duration(milliseconds: 50),
    );
  });

  group('MovieLocalDataSourceImpl', () {
    test('returns right values when nothing is cached', () async {
      final dataSource = MovieLocalDataSourceImpl(cache: cache);

      expect(dataSource.get(1), isNull);
      expect(dataSource.isFresh(1), isFalse);
    });

    test(
      'returns cached data and considers it fresh before timeToLive',
      () async {
        final dataSource = MovieLocalDataSourceImpl(cache: cache);

        dataSource.put(paginatedMovies);

        expect(dataSource.get(1), paginatedMovies);
        expect(dataSource.isFresh(1), isTrue);
      },
    );

    test(
      'keeps outdated data but stops considering it fresh after timeToLive',
      () async {
        final dataSource = MovieLocalDataSourceImpl(cache: cache);

        dataSource.put(paginatedMovies);
        expect(dataSource.isFresh(1), isTrue);

        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(dataSource.isFresh(1), isFalse);
        expect(dataSource.get(1), paginatedMovies);
      },
    );

    test('emits on updates stream when putting data', () async {
      final dataSource = MovieLocalDataSourceImpl(cache: cache);

      final updates = <PaginatedMovies>[];

      final subscription = dataSource.updates.listen(
        (paginatedMovies) => updates.add(paginatedMovies),
      );

      dataSource.put(paginatedMovies);
      await Future<void>.delayed(Duration.zero);

      expect(updates, [paginatedMovies]);

      await subscription.cancel();
    });
  });
}
