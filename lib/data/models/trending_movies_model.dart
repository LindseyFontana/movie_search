import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';

class TrendingMoviesModel extends TrendingMovies {
  const TrendingMoviesModel({required super.page, required super.movies});

  factory TrendingMoviesModel.fromJson(Map<String, dynamic> json) {
    final movies = json["results"].map((result) {
      final json = result as Map<String, dynamic>;
      return Movie(
        title: json["title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
      );
    }).toList();

    return TrendingMoviesModel(movies: movies, page: json["page"]);
  }

  Map<String, dynamic> toJson(Movie movie) => {
    "title": movie.title,
    "overview": movie.overview,
    "poster_path": movie.posterPath,
  };
}
