part of 'search_movies_bloc.dart';

sealed class SearchMoviesState {
  final PaginetedMovies? paginetedMovies;
  final String? query;

  SearchMoviesState({this.paginetedMovies, this.query});
}

final class InitialState extends SearchMoviesState {}

final class LoadingState extends SearchMoviesState {
  LoadingState();
}

final class LoadingMoreMoviesState extends SearchMoviesState {
  LoadingMoreMoviesState({super.paginetedMovies, super.query});
}

final class SuccessState extends SearchMoviesState {
  SuccessState({super.paginetedMovies, super.query});
}

final class ErrorState extends SearchMoviesState {
  final String? message;

  ErrorState({this.message});
}
