import 'package:movie_search/domain/entities/movie.dart';

class MovieResponseModel extends Movie {
  const MovieResponseModel({
    required super.id,
    required super.title,
    required super.overview,
    super.posterPath,
    super.backdropPath,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      MovieResponseModel(
        id: json["id"],
        title: json["title"],
        overview: json["overview"],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
      );

  static Map<String, dynamic> toJson(Movie movie) => {
    "id": movie.id,
    "title": movie.title,
    "overview": movie.overview,
    "poster_path": movie.posterPath,
    "backdrop_path": movie.backdropPath,
  };
}
