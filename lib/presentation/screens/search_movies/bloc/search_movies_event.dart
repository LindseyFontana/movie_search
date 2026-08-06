part of 'search_movies_bloc.dart';

sealed class MoviesEvent {}

final class SearchMoviesEvent extends MoviesEvent {
  final String query;

  SearchMoviesEvent(this.query);
}

final class SearchMoreMoviesEvent extends MoviesEvent {
  final PaginetedMovies? paginetedMovies;
  final String query;

  SearchMoreMoviesEvent(this.query, this.paginetedMovies);
}

final class GetTrendingMoviesEvent extends MoviesEvent {
  GetTrendingMoviesEvent();
}

final class LoadMoreTrendingMoviesEvent extends MoviesEvent {
  final PaginetedMovies? trendingMovies;

  LoadMoreTrendingMoviesEvent([this.trendingMovies]);
}
