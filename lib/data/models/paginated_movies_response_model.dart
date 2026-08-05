import 'package:movie_search/data/models/movie_response_model.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';

class PaginetedMoviesResponseModel extends PaginetedMovies {
  const PaginetedMoviesResponseModel({
    required super.page,
    required super.movies,
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
    );
  }

  static Map<String, dynamic> toJson(PaginetedMovies trendingMovies) => {
    "page": trendingMovies.page,
    "results": trendingMovies.movies
        .map((movie) => MovieResponseModel.toJson(movie))
        .toList(),
  };
}
