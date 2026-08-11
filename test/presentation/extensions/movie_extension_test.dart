import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/extensions/movie_extension.dart';

void main() {
  const movie = Movie(id: 1, title: 'Movie One', overview: 'Overview one');

  group('getImageUrl', () {
    test('returns the TMDB image url when path is provided', () {
      expect(
        movie.getImageUrl(size: 'w154', path: '/poster.jpg'),
        'https://image.tmdb.org/t/p/w154/poster.jpg',
      );
    });

    test('returns null when path is null', () {
      expect(movie.getImageUrl(size: 'w154', path: null), isNull);
    });

    test('returns null when path is empty', () {
      expect(movie.getImageUrl(size: 'w154', path: ''), isNull);
    });
  });
}
