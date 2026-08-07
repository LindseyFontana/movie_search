import 'package:equatable/equatable.dart';
import 'package:movie_search/domain/entities/movie.dart';

class PaginatedMovies extends Equatable {
  final int page;
  final int totalPages;
  final List<Movie> movies;

  const PaginatedMovies({
    required this.page,
    required this.movies,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [page, totalPages, movies];
}
