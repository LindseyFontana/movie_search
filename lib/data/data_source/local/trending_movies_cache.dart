import 'dart:convert';

import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrendingMoviesCache {
  TrendingMoviesCache(
    this.storage, {
    this.timeToLive = const Duration(hours: 8),
  });

  static const key = 'trending-movies';

  final SharedPreferences storage;

  final Duration timeToLive;

  Map<String, dynamic>? _readCache() {
    final cachedValues = storage.getString(key);

    return cachedValues != null ? jsonDecode(cachedValues) : null;
  }

  PaginatedMovies? get(int page) {
    final cachedEntries = _readCache();

    if (cachedEntries == null) return null;

    final rawEntry = cachedEntries[page.toString()];

    return rawEntry != null
        ? _CacheEntry.fromJson(rawEntry).paginatedMovies
        : null;
  }

  bool isFresh(int page) {
    final cachedEntries = _readCache();

    if (cachedEntries == null) return false;

    final rawEntry = cachedEntries[page.toString()];
    if (rawEntry == null) return false;

    final entry = _CacheEntry.fromJson(rawEntry);

    return DateTime.now().difference(entry.fetchedAt) < timeToLive;
  }

  void put(PaginatedMovies paginatedMovies) {
    final cachedEntries = _readCache() ?? <String, dynamic>{};

    cachedEntries[paginatedMovies.page.toString()] = _CacheEntry(
      paginatedMovies: paginatedMovies,
      fetchedAt: DateTime.now(),
    ).toJson;

    storage.setString(key, jsonEncode(cachedEntries));
  }
}

class _CacheEntry {
  const _CacheEntry({required this.paginatedMovies, required this.fetchedAt});

  final PaginatedMovies paginatedMovies;
  final DateTime fetchedAt;

  factory _CacheEntry.fromJson(Map<String, dynamic> json) => _CacheEntry(
    fetchedAt: DateTime.parse(json["fetchedAt"] as String),
    paginatedMovies: PaginatedMovies.fromJson(
      json["paginatedMovies"] as Map<String, dynamic>,
    ),
  );

  Map<String, dynamic> get toJson => {
    "fetchedAt": fetchedAt.toIso8601String(),
    "paginatedMovies": PaginatedMovies.toJson(paginatedMovies),
  };
}
