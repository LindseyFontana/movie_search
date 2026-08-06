import 'package:movie_search/data/models/movie_response_model.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';

class PaginetedMoviesResponseModel extends PaginetedMovies {
  const PaginetedMoviesResponseModel({
    required super.page,
    required super.movies,
    required super.totalPages,
  });

  factory PaginetedMoviesResponseModel.fromJson(Map<String, dynamic> json) {
    final List<MovieResponseModel> movies = json["results"]
        .where((movie) {
          final String? title = movie['title'];
          final String? overview = movie['overview'];

          return title != null &&
              title.isNotEmpty &&
              overview != null &&
              overview.isNotEmpty;
        })
        .map<MovieResponseModel>((result) {
          return MovieResponseModel.fromJson(result);
        })
        .toList();

    return PaginetedMoviesResponseModel(
      page: json["page"],
      totalPages: json["total_pages"],
      movies: movies.toSet().toList(),
    );
  }

  static Map<String, dynamic> toJson(PaginetedMovies paginatedMovies) => {
    "page": paginatedMovies.page,
    "total_pages": paginatedMovies.totalPages,
    "results": paginatedMovies.movies
        .map((movie) => MovieResponseModel.toJson(movie))
        .toList(),
  };
}
