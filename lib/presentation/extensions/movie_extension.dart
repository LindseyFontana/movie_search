import 'package:movie_search/domain/entities/movie.dart';

extension MovieExtension on Movie {
  String? getImageUrl({required String size, String? path}) {
    return path != null && path.isNotEmpty
        ? "https://image.tmdb.org/t/p/$size$path"
        : null;
  }
}
