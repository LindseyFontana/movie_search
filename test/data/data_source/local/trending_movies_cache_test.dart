import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/local/trending_movies_cache.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const firstPage = PaginatedMovies(
    page: 1,
    totalPages: 3,
    movies: [Movie(id: 1, title: 'Movie One', overview: 'Overview one')],
  );

  const secondPage = PaginatedMovies(
    page: 2,
    totalPages: 3,
    movies: [Movie(id: 2, title: 'Movie Two', overview: 'Overview two')],
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

  group('TrendingMoviesCache', () {
    test('returns null and is not fresh when nothing is cached', () {
      expect(cache.get(1), isNull);
      expect(cache.isFresh(1), isFalse);
    });

    test('returns cached data after call put method', () {
      cache.put(firstPage);

      expect(cache.get(1), firstPage);
    });

    test('considers cached data fresh before timeToLive', () {
      cache.put(firstPage);

      expect(cache.isFresh(1), isTrue);
    });

    test(
      'keeps outdated data but stops considering it fresh after timeToLive',
      () async {
        cache.put(firstPage);
        expect(cache.isFresh(1), isTrue);

        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(cache.isFresh(1), isFalse);
        expect(cache.get(1), firstPage);
      },
    );

    test('caches each page independently', () {
      cache.put(firstPage);
      cache.put(secondPage);

      expect(cache.get(1), firstPage);
      expect(cache.get(2), secondPage);
    });

    test('returns null when only a different page is cached', () {
      cache.put(secondPage);

      expect(cache.get(1), isNull);
      expect(cache.isFresh(1), isFalse);
    });

    test('overwrites existing entry when putting the same page again', () {
      const updatedFirstPage = PaginatedMovies(
        page: 1,
        totalPages: 3,
        movies: [
          Movie(id: 1, title: 'Movie Updated', overview: 'Updated overview'),
        ],
      );

      cache.put(firstPage);
      cache.put(updatedFirstPage);

      expect(cache.get(1), updatedFirstPage);
    });

    test('persists cached entries across instances', () async {
      cache.put(firstPage);

      final secondCache = TrendingMoviesCache(
        await SharedPreferences.getInstance(),
        timeToLive: const Duration(hours: 4),
      );

      expect(secondCache.get(1), firstPage);
      expect(secondCache.isFresh(1), isTrue);
    });

    test('is not fresh after timeToLive across instances', () async {
      cache.put(firstPage);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final secondCache = TrendingMoviesCache(
        await SharedPreferences.getInstance(),
        timeToLive: const Duration(milliseconds: 50),
      );

      expect(secondCache.get(1), firstPage);
      expect(secondCache.isFresh(1), isFalse);
    });
  });
}
