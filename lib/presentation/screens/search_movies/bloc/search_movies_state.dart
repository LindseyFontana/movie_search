part of 'search_movies_bloc.dart';

sealed class SearchMoviesState {
  final PaginetedMovies? paginetedMovies;

  SearchMoviesState({this.paginetedMovies});
}

final class InitialState extends SearchMoviesState {}

final class LoadingState extends SearchMoviesState {
  LoadingState();
}

final class LoadingMoreMoviesState extends SearchMoviesState {
  LoadingMoreMoviesState({super.paginetedMovies});
}

final class SuccessState extends SearchMoviesState {
  SuccessState({super.paginetedMovies});
}

final class ErrorState extends SearchMoviesState {
  final int? statusCode;
  final String? message;

  ErrorState({this.statusCode, this.message});
}
