part of 'movies_search_bloc.dart';

sealed class MoviesEvent {}

final class MoviesSearchEvent extends MoviesEvent {
  final String query;

  MoviesSearchEvent(this.query);
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
