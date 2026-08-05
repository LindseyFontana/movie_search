part of 'search_movies_bloc.dart';

sealed class MoviesEvent {}

final class SearchMoviesEvent extends MoviesEvent {
  final String query;

  SearchMoviesEvent(this.query);
}

final class GetTrendingMoviesEvent extends MoviesEvent {
  final PaginetedMovies? trendingMovies;

  GetTrendingMoviesEvent([this.trendingMovies]);
}

final class LoadMoreTrendingMoviesEvent extends MoviesEvent {
  final PaginetedMovies? trendingMovies;

  LoadMoreTrendingMoviesEvent([this.trendingMovies]);
}
