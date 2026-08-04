part of 'search_movies_bloc.dart';

sealed class MoviesEvent {}

final class SearchMoviesEvent extends MoviesEvent {}

final class GetTrendingMoviesEvent extends MoviesEvent {
  final TrendingMovies? trendingMovies;

  GetTrendingMoviesEvent([this.trendingMovies]);
}

final class LoadMoreTrendingMoviesEvent extends MoviesEvent {
  final TrendingMovies? trendingMovies;

  LoadMoreTrendingMoviesEvent([this.trendingMovies]);
}
