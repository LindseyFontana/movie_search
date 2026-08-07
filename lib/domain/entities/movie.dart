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

  String? getImageUrl({required String size, String? path}) {
    return path != null && path.isNotEmpty
        ? "https://image.tmdb.org/t/p/$size$path"
        : null;
  }

  @override
  List<Object?> get props => [id, title, overview, posterPath, backdropPath];
}
