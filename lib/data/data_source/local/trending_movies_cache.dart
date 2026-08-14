import 'package:movie_search/domain/entities/paginated_movies.dart';

class TrendingMoviesCache {
  TrendingMoviesCache({this.ttl = _defaultTtl});

  static const _defaultTtl = Duration(hours: 2);

  final Duration ttl;

  final Map<int, _CacheEntry> _entries = {};

  PaginatedMovies? get(int page) => _entries[page]?.paginatedMovies;

  bool isFresh(int page) {
    final entry = _entries[page];

    return entry != null && DateTime.now().difference(entry.fetchedAt) < ttl;
  }

  void put(PaginatedMovies paginatedMovies) {
    _entries[paginatedMovies.page] = _CacheEntry(
      paginatedMovies: paginatedMovies,
      fetchedAt: DateTime.now(),
    );
  }
}

class _CacheEntry {
  const _CacheEntry({required this.paginatedMovies, required this.fetchedAt});

  final PaginatedMovies paginatedMovies;
  final DateTime fetchedAt;
}
