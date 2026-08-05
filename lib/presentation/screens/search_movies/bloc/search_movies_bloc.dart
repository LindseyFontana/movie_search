import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/domain/entities/search_params.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';
part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<MoviesEvent, SearchMoviesState> {
  final GetTrendingMoviesUseCase trendingMovies;
  final SearchMoviesUseCase searchedMovies;

  static const _firstPage = 1;

  SearchMoviesBloc(this.trendingMovies, this.searchedMovies)
    : super(InitialState()) {
    on<GetTrendingMoviesEvent>((event, emit) async {
      emit(LoadingState());

      final result = await trendingMovies.call(_firstPage);

      result.fold(
        (error) => emit(ErrorState()),
        (trendingMovies) => emit(SuccessState(paginetedMovies: trendingMovies)),
      );
    });

    on<LoadMoreTrendingMoviesEvent>((event, emit) async {
      emit(LoadingMoreMoviesState(paginetedMovies: event.trendingMovies));

      final trendingMoviesOld = event.trendingMovies;

      final pageToSearch = trendingMoviesOld?.page != null
          ? trendingMoviesOld!.page + 1
          : _firstPage;

      final result = await trendingMovies.call(pageToSearch);

      result.fold((error) => emit(ErrorState()), (trendingMoviesNew) {
        final movies = trendingMoviesOld != null
            ? [...trendingMoviesOld.movies, ...trendingMoviesNew.movies]
            : trendingMoviesNew.movies;

        emit(
          SuccessState(
            paginetedMovies: PaginetedMovies(
              page: trendingMoviesNew.page,
              movies: movies,
            ),
          ),
        );
        return;
      });
    }, transformer: droppable());

    on<SearchMoviesEvent>((event, emit) async {
      emit(LoadingState());

      final result = await searchedMovies.call(
        SearchParams(query: event.query, pageToSearch: _firstPage),
      );

      result.fold(
        (error) => emit(ErrorState()),
        (searchedMovies) => emit(SuccessState(paginetedMovies: searchedMovies)),
      );
    });
  }
}
