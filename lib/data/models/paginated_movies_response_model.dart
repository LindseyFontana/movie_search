import 'package:movie_search/data/models/movie_response_model.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';

class PaginetedMoviesResponseModel extends PaginetedMovies {
  const PaginetedMoviesResponseModel({
    required super.page,
    required super.movies,
    required super.totalPage,
  });

  factory PaginetedMoviesResponseModel.fromJson(Map<String, dynamic> json) {
    final List<MovieResponseModel> movies = json["results"]
        .map<MovieResponseModel>(
          (result) => MovieResponseModel.fromJson(result),
        )
        .toList();

    return PaginetedMoviesResponseModel(
      movies: movies.toSet().toList(),
      page: json["page"],
      totalPage: json["total_pages"],
    );
  }

  static Map<String, dynamic> toJson(PaginetedMovies paginatedMovies) => {
    "page": paginatedMovies.page,
    "total_pages": paginatedMovies.totalPage,
    "results": paginatedMovies.movies
        .map((movie) => MovieResponseModel.toJson(movie))
        .toList(),
  };
}
