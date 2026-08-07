import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/search_params.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';
part 'movies_search_event.dart';
part 'movies_search_state.dart';

class MoviesSearchBloc extends Bloc<MoviesEvent, MoviesSearchState> {
  final GetTrendingMoviesUseCase getTrendingMovies;
  final SearchMoviesUseCase searchMovies;

  static const _firstPage = 1;

  MoviesSearchBloc(this.getTrendingMovies, this.searchMovies)
    : super(InitialState()) {
    on<GetTrendingMoviesEvent>((event, emit) async {
      emit(LoadingState());

      final result = await getTrendingMovies.call(_firstPage);

      result.fold((error) => emit(ErrorState(error)), (trendingMovies) {
        emit(SuccessState(paginetedMovies: trendingMovies));
      });
    });

    on<LoadMoreTrendingMoviesEvent>((event, emit) async {
      emit(LoadingMoreMoviesState(paginetedMovies: event.trendingMovies));

      final currentPage = event.trendingMovies;

      final nextPageNumber = _getNextPage(currentPage);

      final result = await getTrendingMovies.call(nextPageNumber);

      result.fold((error) => emit(ErrorState(error)), (nextPage) {
        emit(
          SuccessState(
            paginetedMovies: _getPaginetedMovies(
              currentPage: currentPage,
              nextPage: nextPage,
            ),
          ),
        );
      });
    }, transformer: droppable());

    on<MoviesSearchEvent>((event, emit) async {
      emit(LoadingState());

      final result = await searchMovies.call(
        SearchParams(query: event.query, pageToSearch: _firstPage),
      );

      result.fold(
        (error) => emit(ErrorState(error)),
        (nextPage) =>
            emit(SuccessState(paginetedMovies: nextPage, query: event.query)),
      );
    });

    on<SearchMoreMoviesEvent>((event, emit) async {
      emit(
        LoadingMoreMoviesState(
          paginetedMovies: event.paginetedMovies,
          query: event.query,
        ),
      );

      final currentPage = event.paginetedMovies;

      final nextPageNumber = _getNextPage(currentPage);

      final result = await searchMovies.call(
        SearchParams(query: event.query, pageToSearch: nextPageNumber),
      );

      result.fold((error) => emit(ErrorState(error)), (nextPage) {
        emit(
          SuccessState(
            paginetedMovies: _getPaginetedMovies(
              currentPage: currentPage,
              nextPage: nextPage,
            ),
            query: event.query,
          ),
        );
      });
    }, transformer: droppable());
  }

  PaginetedMovies _getPaginetedMovies({
    PaginetedMovies? currentPage,
    required PaginetedMovies nextPage,
  }) {
    return PaginetedMovies(
      page: nextPage.page,
      totalPages: nextPage.totalPages,
      movies: _appendMovies(currentPage: currentPage, nextPage: nextPage),
    );
  }

  List<Movie> _appendMovies({
    PaginetedMovies? currentPage,
    required PaginetedMovies nextPage,
  }) {
    return currentPage != null
        ? <Movie>{...currentPage.movies, ...nextPage.movies}.toList()
        : nextPage.movies;
  }

  int _getNextPage(PaginetedMovies? currentPage) {
    return currentPage != null ? currentPage.page + 1 : _firstPage;
  }
}
