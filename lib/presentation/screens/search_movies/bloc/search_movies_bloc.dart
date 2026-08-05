import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';
part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<MoviesEvent, SearchMoviesState> {
  final GetTrendingMoviesUseCase usecase;

  static const _firstPage = 1;

  SearchMoviesBloc(this.usecase) : super(InitialState()) {
    on<GetTrendingMoviesEvent>((event, emit) async {
      emit(LoadingState());

      final result = await usecase.call(_firstPage);

      result.fold(
        (error) => emit(ErrorState()),
        (trendingMovies) => emit(SuccessState(trendingMovies: trendingMovies)),
      );
    });

    on<LoadMoreTrendingMoviesEvent>((event, emit) async {
      emit(LoadingMoreMoviesState(trendingMovies: event.trendingMovies));

      final trendingMoviesOld = event.trendingMovies;

      final pageToSearch = trendingMoviesOld?.page != null
          ? trendingMoviesOld!.page + 1
          : _firstPage;

      final result = await usecase.call(pageToSearch);

      result.fold((error) => emit(ErrorState()), (trendingMoviesNew) {
        final movies = trendingMoviesOld != null
            ? [...trendingMoviesOld.movies, ...trendingMoviesNew.movies]
            : trendingMoviesNew.movies;

        emit(
          SuccessState(
            trendingMovies: TrendingMovies(
              page: trendingMoviesNew.page,
              movies: movies,
            ),
          ),
        );
        return;
      });
    }, transformer: droppable());
  }
}
