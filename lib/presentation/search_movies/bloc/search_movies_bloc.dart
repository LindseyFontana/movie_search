import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';

part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<MoviesEvent, SearchMoviesState> {
  final GetTrendingMoviesUseCase usecase;

  SearchMoviesBloc(this.usecase) : super(InitialState()) {
    on<GetTrendingMoviesEvent>((event, emit) async {
      emit(LoadingState());

      final result = await usecase.call(null);

      result.fold(
        (error) => emit(ErrorState()),
        (movies) => emit(SuccessState(movies)),
      );
    });
  }
}
