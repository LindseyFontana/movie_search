import 'package:movie_search/data/models/movie_response_model.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';

class TrendingMoviesModel extends TrendingMovies {
  const TrendingMoviesModel({required super.page, required super.movies});

  factory TrendingMoviesModel.fromJson(Map<String, dynamic> json) {
    final List<MovieResponseModel> movies = json["results"]
        .map<MovieResponseModel>(
          (result) => MovieResponseModel.fromJson(result),
        )
        .toList();

    return TrendingMoviesModel(
      movies: movies.toSet().toList(),
      page: json["page"],
    );
  }

  Map<String, dynamic> toJson(TrendingMovies trendingMovies) => {
    "page": trendingMovies.page,
    "results": trendingMovies.movies
        .map(
          (movie) => {
            "title": movie.title,
            "overview": movie.overview,
            "poster_path": movie.posterPath,
          },
        )
        .toList(),
  };
}
