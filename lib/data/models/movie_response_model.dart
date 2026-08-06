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
        posterPath: _getImageUrl(json['poster_path']),
        backdropPath: _getImageUrl(json["backdrop_path"]),
      );

  static Map<String, dynamic> toJson(Movie movie) => {
    "title": movie.title,
    "overview": movie.overview,
    "poster_path": movie.posterPath,
    "backdrop_path": movie.backdropPath,
  };

  static String? _getImageUrl(String? url) {
    return url != null && url.isNotEmpty
        ? "https://image.tmdb.org/t/p/w185$url"
        : null;
  }
}
