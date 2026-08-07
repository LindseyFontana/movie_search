part of 'movies_search_bloc.dart';

sealed class MoviesEvent {}

final class SearchMoviesEvent extends MoviesEvent {
  final String query;

  SearchMoviesEvent(this.query);
}

final class SearchMoreMoviesEvent extends MoviesEvent {
  final PaginatedMovies? paginatedMovies;
  final String query;

  SearchMoreMoviesEvent(this.query, this.paginatedMovies);
}

final class GetTrendingMoviesEvent extends MoviesEvent {
  GetTrendingMoviesEvent();
}

final class LoadMoreTrendingMoviesEvent extends MoviesEvent {
  final PaginatedMovies? trendingMovies;

  LoadMoreTrendingMoviesEvent([this.trendingMovies]);
}
