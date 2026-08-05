import 'package:equatable/equatable.dart';
import 'package:movie_search/domain/entities/movie.dart';

class PaginetedMovies extends Equatable {
  final int page;
  final List<Movie> movies;

  const PaginetedMovies({required this.page, required this.movies});

  @override
  List<Object?> get props => [page, movies];
}
