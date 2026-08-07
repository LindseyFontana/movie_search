import 'package:movie_search/data/models/movie_response_model.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

class PaginatedMoviesResponseModel {
  final int page;
  final int totalPages;
  final List<MovieResponseModel> movies;

  const PaginatedMoviesResponseModel({
    required this.page,
    required this.movies,
    required this.totalPages,
  });

  factory PaginatedMoviesResponseModel.fromJson(Map<String, dynamic> json) {
    final results = json["results"];
    final List<MovieResponseModel> movies =
        results != null && results is List && results.isNotEmpty
        ? json["results"]
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
              .toSet()
              .toList()
        : [];

    return PaginatedMoviesResponseModel(
      page: json["page"],
      totalPages: json["total_pages"],
      movies: movies,
    );
  }

  static Map<String, dynamic> toJson(PaginatedMovies paginatedMovies) => {
    "page": paginatedMovies.page,
    "total_pages": paginatedMovies.totalPages,
    "results": paginatedMovies.movies
        .map((movie) => MovieResponseModel.toJson(movie))
        .toList(),
  };

  PaginatedMovies toEntity() => PaginatedMovies(
    page: page,
    totalPages: totalPages,
    movies: movies.map((movie) => movie.toEntity()).toList(),
  );
}
