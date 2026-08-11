part of 'movies_search_bloc.dart';

sealed class MoviesSearchState extends Equatable {
  final PaginatedMovies? paginatedMovies;
  final String? query;

  const MoviesSearchState({this.paginatedMovies, this.query});

  @override
  List<Object?> get props => [paginatedMovies, query];
}

final class InitialState extends MoviesSearchState {
  const InitialState();
}

final class LoadingState extends MoviesSearchState {
  const LoadingState();
}

final class LoadingMoreMoviesState extends MoviesSearchState {
  const LoadingMoreMoviesState({super.paginatedMovies, super.query});
}

final class SuccessState extends MoviesSearchState {
  const SuccessState({super.paginatedMovies, super.query});
}

final class ErrorState extends MoviesSearchState {
  final Failure error;

  const ErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
