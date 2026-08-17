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

  factory PaginatedMovies.fromJson(Map<String, dynamic> json) {
    final results = json["results"];
    final List<Movie> movies =
        results != null && results is List && results.isNotEmpty
        ? json["results"].map<Movie>((result) {
            return Movie.fromJson(result);
          }).toList()
        : [];

    return PaginatedMovies(
      page: json["page"],
      totalPages: json["total_pages"],
      movies: movies,
    );
  }

  static Map<String, dynamic> toJson(PaginatedMovies paginatedMovies) => {
    "page": paginatedMovies.page,
    "total_pages": paginatedMovies.totalPages,
    "results": paginatedMovies.movies
        .map((movie) => Movie.toJson(movie))
        .toList(),
  };
}
