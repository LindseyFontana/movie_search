part of 'search_movies_bloc.dart';

sealed class SearchMoviesState {
  final TrendingMovies? trendingMovies;

  SearchMoviesState({this.trendingMovies});
}

final class InitialState extends SearchMoviesState {}

final class LoadingState extends SearchMoviesState {
  LoadingState();
}

final class LoadingMoreMoviesState extends SearchMoviesState {
  LoadingMoreMoviesState({super.trendingMovies});
}

final class SuccessState extends SearchMoviesState {
  SuccessState({super.trendingMovies});
}

final class ErrorState extends SearchMoviesState {
  ErrorState({this.statusCode, this.message});
  final int? statusCode;
  final String? message;
}
