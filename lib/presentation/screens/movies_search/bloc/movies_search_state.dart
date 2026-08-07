part of 'movies_search_bloc.dart';

sealed class MoviesSearchState {
  final PaginatedMovies? paginatedMovies;
  final String? query;

  MoviesSearchState({this.paginatedMovies, this.query});
}

final class InitialState extends MoviesSearchState {}

final class LoadingState extends MoviesSearchState {
  LoadingState();
}

final class LoadingMoreMoviesState extends MoviesSearchState {
  LoadingMoreMoviesState({super.paginatedMovies, super.query});
}

final class SuccessState extends MoviesSearchState {
  SuccessState({super.paginatedMovies, super.query});
}

final class ErrorState extends MoviesSearchState {
  final Failure error;

  ErrorState(this.error);
}
