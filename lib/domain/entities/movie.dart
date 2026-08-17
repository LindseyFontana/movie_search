import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({
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

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
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

  @override
  List<Object?> get props => [id, title, overview, posterPath, backdropPath];
}
