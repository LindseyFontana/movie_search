import 'package:equatable/equatable.dart';
import 'package:movie_search/domain/entities/movie.dart';

class TrendingMovies extends Equatable {
  final int page;
  final List<Movie> movies;

  const TrendingMovies({required this.page, required this.movies});

  @override
  List<Object?> get props => [page, movies];
}
