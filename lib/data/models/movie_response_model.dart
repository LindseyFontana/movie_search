import 'package:movie_search/domain/entities/movie.dart';

class MovieResponseModel extends Movie {
  const MovieResponseModel({
    required super.title,
    required super.overview,
    required super.posterPath,
  });

  static const _baseURL = "https://image.tmdb.org/t/p/w342";

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      MovieResponseModel(
        title: json["title"],
        overview: json["overview"],
        posterPath: json["poster_path"] != null
            ? _baseURL + json["poster_path"]
            : 'image-quebrada',
      );

  Map<String, dynamic> toJson(Movie movie) => {
    "title": movie.title,
    "overview": movie.overview,
    "poster_path": movie.posterPath,
  };
}
