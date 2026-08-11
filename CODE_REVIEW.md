# Code Review: movie_search

Review date: 2026-08-07. Project passes `flutter analyze` cleanly.

## 1. Bugs (runtime crash risks)

1. **`_buildDefault` uses `Expanded` under a non-Flex parent** — `movies_search_screen.dart:205-215`. `_buildDefault` returns `Expanded` as the child of `GestureDetector`, whose parent is a `GridView`. `Expanded` must be a direct child of a `Row`/`Column`/`Flex`. This throws `Incorrect use of ParentDataWidget` at runtime. It's reachable too: `paginated_movies_response_model.dart:14-30` filters out movies missing `title`/`overview` but **not** missing `poster_path`. Fix: return the `Container` directly (the grid tile already bounds it).
2. **Force-unwrap on optional image paths** — `movie_details_screen.dart:86` `Image.network(url!)`. If `backdropPath`/`posterPath` is null (no placeholder guard like the list screen has), this crashes. Handle the null case.
3. **Nested `Expanded` in the error path** — `custom_error_widget.dart:12` returns `Expanded` at its root, but it's already wrapped in an `Expanded` at `movies_search_screen.dart:113`. One is redundant and the stacking is fragile/error-prone. Make `CustomErrorWidget` return a `Center`/`Column` and keep a single `Expanded` at the `BlocBuilder` level.
4. **`MovieResponseModel.toJson` omits `id`** (`movie_response_model.dart:21-26`) while `fromJson` reads it — round-trips silently lose the id.

## 2. Performance

5. **A new `CacheManager` created on every grid item, on every rebuild** — `movies_search_screen.dart:192-198`. `_buildMoviePoster` instantiates `CacheManager(Config(...))` per item, so each scroll/frame spawns cache stores. Create one shared instance (static/DI/`DefaultCacheManager`) and reuse it.
6. **`MovieDetailsScreen` uses uncached `Image.network`** (`movie_details_screen.dart:85`) while the list uses `CachedNetworkImage`. Be consistent — reuse cached_network_image for backdrop/poster.
7. **A network connectivity probe on every request** — `http_service.dart:13` calls `InternetConnection().hasInternetAccess` before each API call (that check itself hits the network). It also creates a new instance each time. Remove the pre-check and map Dio's `connectionError`/timeout `DioException`s to `ConnectionError` instead.
8. **No Dio timeouts** — `http_service.dart:6` `Dio()` with defaults means a hung request blocks forever. Set `connectTimeout`/`receiveTimeout` (and ideally a shared `BaseOptions` so auth headers stop being duplicated per method in `movie_data_source.dart`).

## 3. Clean code / architecture

9. **Data models extend domain entities** — `MovieResponseModel extends Movie`, `PaginatedMoviesResponseModel extends PaginatedMovies`. This couples the data layer to domain and leaks serialization into entities. Prefer composition with `toEntity()`/`toModel()` mapping.
10. **Service locator used directly in widgets** — `movies_search_screen.dart:23` and `endless_scrolling_widget.dart:29` call `getIt<MoviesSearchBloc>()`. Inject via `BlocProvider`/constructor for testability.
11. **Bloc is a lazy singleton** (`dependecy_injection.dart:30`) so search/trending state survives navigation and resets. Register it as a factory and provide it per-screen; `HttpService` is a factory (fine) but only ever resolved once.
12. **Generic error handler discards the real error** — `use_case.dart:27-34` catches everything and returns `"Unkow error"`, losing the original exception. Include `error.toString()` and log it. Same in `http_service.dart:31-33`.
13. **Events vs. bloc naming confusion** — `MoviesSearchEvent` lives inside `MoviesSearchBloc`. Rename to `SearchMoviesEvent`/`SearchMoviesLoadMoreEvent` etc. to avoid `MoviesSearch...Event` ambiguity.
14. **Dead code / redundant params**: unused `bloc` in `endless_scrolling_widget.dart:29`; stray `return;` after `emit` in the fold callbacks (`movies_search_bloc.dart:27,49,93`); `EndlessScrolling.itemCount` is derivable from `paginatedMovies.movies.length`; `_getNextPage` (`movies_search_bloc.dart:118-120`) has an unnecessary `currentPage?.page != null ? currentPage!.page...` — just use `currentPage != null ? currentPage.page + 1 : _firstPage`.
15. **URL building lives in the domain entity** — `movie.dart:18-22` `getImageUrl` mixes presentation with domain and takes a redundant `path` param. Move to a presentation helper/extension.
16. **Mixed language strings** — data/domain error messages are English ("Connection error", "Response is a null value"), UI is pt-BR. Centralize; internal messages are fine in English but keep them consistent.
17. **Empty `test/` directory** — add unit/widget tests (models, `fromJson`, bloc states) and at least a smoke test.

## 4. Spelling / grammar / naming

| Current | Should be |
|---|---|
| `PaginatedMovies`, `PaginatedMovies` (entity, model, bloc, screen) | `PaginatedMovies` |
| `ErrorType.unknow` / `"Unkow error"` (errors.dart:1,30, use_case.dart:31) | `unknown` / `"Unknown error"` |
| `dependecy_injection.dart` | `dependency_injection.dart` |
| `BackButtom` (widget file + usages) | `BackButtonWidget` (avoid Material's `BackButton`) |
| `_scrollController` (endless_scrolling_widget.dart:28) | `_scrollController` |
| `loaderWidth` (movie_details_screen.dart:25,56,81) | `loaderWidth` |
| `dartTheme` (theme.dart:3) | `darkTheme` |
| `pubspec.yaml:2` `"A new Flutter project."` | real description |
| `_inputTextController.text = ""` (movies_search_screen.dart:77) | `.clear()` |

## Minor UX details

- `ValueListenableBuilder` reads `title.value` instead of the builder's `value` param (movies_search_screen.dart:101).
- The `title` `ValueNotifier` can be derived from `state.query`, eliminating the notifier entirely.
- The IntelliJ run config (`main_dart.xml`) is missing `--dart-define-from-file .env.json` (only VSCode's `launch.json` has it).
- Inline `TextStyle(fontSize: ...)` should move into `ThemeData.textTheme`.

## Suggested implementation order

1. Fix the three crash bugs (items 1-3).
2. `CacheManager` perf fix (item 5).
3. Renaming/mapping refactor pass (items 4, 9, 12-15, and the spelling table).
