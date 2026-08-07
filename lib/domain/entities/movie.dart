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

  @override
  List<Object?> get props => [id, title, overview, posterPath, backdropPath];
}
