import 'package:movie_search/domain/entities/movie.dart';

class MovieResponseModel extends Movie {
  const MovieResponseModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
  });

  static const _baseURL = "https://image.tmdb.org/t/p/w342";

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      MovieResponseModel(
        id: json["id"],
        title: json["title"],
        overview: json["overview"],
        posterPath: json["poster_path"] != null
            ? _baseURL + json["poster_path"]
            : 'image-quebrada',
        backdropPath: json["backdrop_path"] != null
            ? _baseURL + json["backdrop_path"]
            : 'image-quebrada',
      );

  static Map<String, dynamic> toJson(Movie movie) => {
    "title": movie.title,
    "overview": movie.overview,
    "poster_path": movie.posterPath,
    "backdrop_path": movie.backdropPath,
  };
}
