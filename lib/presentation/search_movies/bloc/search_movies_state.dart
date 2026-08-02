part of 'search_movies_bloc.dart';

sealed class SearchMoviesState {
  const SearchMoviesState();
}

final class InitialState extends SearchMoviesState {}

final class LoadingState extends SearchMoviesState {}

final class SuccessState extends SearchMoviesState {
  final TrendingMovies trendingMovies;

  const SuccessState(this.trendingMovies);
}

final class ErrorState extends SearchMoviesState {}
