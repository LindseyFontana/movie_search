import 'package:movie_search/domain/entities/movie.dart';

class MovieResponseModel {
  const MovieResponseModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;

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

  Movie toEntity() => Movie(
    id: id,
    title: title,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
  );
}
