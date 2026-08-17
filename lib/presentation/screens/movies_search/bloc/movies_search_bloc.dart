import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/search_params.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';
part 'movies_search_event.dart';
part 'movies_search_state.dart';

class MoviesSearchBloc extends Bloc<MoviesEvent, MoviesSearchState> {
  final GetTrendingMoviesUseCase getTrendingMovies;
  final SearchMoviesUseCase searchMovies;

  static const _firstPage = 1;

  late final StreamSubscription<PaginatedMovies> _trendingUpdatesSubscription;

  MoviesSearchBloc(this.getTrendingMovies, this.searchMovies)
    : super(InitialState()) {
    _trendingUpdatesSubscription = getTrendingMovies.trendingUpdates.listen(
      (paginatedMovies) => add(TrendingMoviesRefreshedEvent(paginatedMovies)),
    );

    on<TrendingMoviesRefreshedEvent>((event, emit) {
      final isOnFirstTrendingPage =
          state.paginatedMovies?.page == 1 &&
          (state.query == null || state.query!.isEmpty);

      if (isOnFirstTrendingPage) {
        emit(SuccessState(paginatedMovies: event.paginatedMovies));
      }
    });

    on<GetTrendingMoviesEvent>((event, emit) async {
      final isShowingTrending =
          state.paginatedMovies != null &&
          (state.query == null || state.query!.isEmpty);

      if (!isShowingTrending) emit(LoadingState());

      final result = await getTrendingMovies.call(_firstPage);

      result.fold((error) => emit(ErrorState(error)), (trendingMovies) {
        emit(SuccessState(paginatedMovies: trendingMovies));
      });
    });

    on<LoadMoreTrendingMoviesEvent>((event, emit) async {
      emit(LoadingMoreMoviesState(paginatedMovies: event.trendingMovies));

      final currentPage = event.trendingMovies;

      final nextPageNumber = _getNextPage(currentPage);

      final result = await getTrendingMovies.call(nextPageNumber);

      result.fold((error) => emit(ErrorState(error)), (nextPage) {
        emit(
          SuccessState(
            paginatedMovies: _getPaginatedMovies(
              currentPage: currentPage,
              nextPage: nextPage,
            ),
          ),
        );
      });
    }, transformer: droppable());

    on<SearchMoviesEvent>((event, emit) async {
      emit(LoadingState());

      final result = await searchMovies.call(
        SearchParams(query: event.query, pageToSearch: _firstPage),
      );

      result.fold(
        (error) => emit(ErrorState(error)),
        (nextPage) =>
            emit(SuccessState(paginatedMovies: nextPage, query: event.query)),
      );
    });

    on<SearchMoreMoviesEvent>((event, emit) async {
      emit(
        LoadingMoreMoviesState(
          paginatedMovies: event.paginatedMovies,
          query: event.query,
        ),
      );

      final currentPage = event.paginatedMovies;

      final nextPageNumber = _getNextPage(currentPage);

      final result = await searchMovies.call(
        SearchParams(query: event.query, pageToSearch: nextPageNumber),
      );

      result.fold((error) => emit(ErrorState(error)), (nextPage) {
        emit(
          SuccessState(
            paginatedMovies: _getPaginatedMovies(
              currentPage: currentPage,
              nextPage: nextPage,
            ),
            query: event.query,
          ),
        );
      });
    }, transformer: droppable());
  }

  PaginatedMovies _getPaginatedMovies({
    PaginatedMovies? currentPage,
    required PaginatedMovies nextPage,
  }) {
    return PaginatedMovies(
      page: nextPage.page,
      totalPages: nextPage.totalPages,
      movies: _appendMovies(currentPage: currentPage, nextPage: nextPage),
    );
  }

  List<Movie> _appendMovies({
    PaginatedMovies? currentPage,
    required PaginatedMovies nextPage,
  }) {
    return currentPage != null
        ? <Movie>{...currentPage.movies, ...nextPage.movies}.toList()
        : nextPage.movies;
  }

  int _getNextPage(PaginatedMovies? currentPage) {
    return currentPage != null ? currentPage.page + 1 : _firstPage;
  }

  @override
  Future<void> close() async {
    await _trendingUpdatesSubscription.cancel();
    await super.close();
  }
}
