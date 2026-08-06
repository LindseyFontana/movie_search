part of 'movies_search_bloc.dart';

sealed class MoviesSearchState {
  final PaginetedMovies? paginetedMovies;
  final String? query;

  MoviesSearchState({this.paginetedMovies, this.query});
}

final class InitialState extends MoviesSearchState {}

final class LoadingState extends MoviesSearchState {
  LoadingState();
}

final class LoadingMoreMoviesState extends MoviesSearchState {
  LoadingMoreMoviesState({super.paginetedMovies, super.query});
}

final class SuccessState extends MoviesSearchState {
  SuccessState({super.paginetedMovies, super.query});
}

final class ErrorState extends MoviesSearchState {
  final Failure error;

  ErrorState(this.error);
}
