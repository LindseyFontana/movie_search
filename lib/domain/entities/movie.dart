import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  final String title;
  final String overview;
  final String posterPath;

  @override
  List<Object?> get props => [title, overview, posterPath];
}
