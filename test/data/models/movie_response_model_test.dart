import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/models/movie_response_model.dart';
import 'package:movie_search/domain/entities/movie.dart';

void main() {
  const movieJson = {
    'id': 1,
    'title': 'Movie One',
    'overview': 'Overview one',
    'poster_path': '/poster1.jpg',
    'backdrop_path': '/backdrop1.jpg',
  };

  group('fromJson', () {
    test('maps all fields correctly', () {
      final model = MovieResponseModel.fromJson(movieJson);

      expect(model.id, 1);
      expect(model.title, 'Movie One');
      expect(model.overview, 'Overview one');
      expect(model.posterPath, '/poster1.jpg');
      expect(model.backdropPath, '/backdrop1.jpg');
    });

    test('maps missing poster and backdrop paths to null', () {
      final model = MovieResponseModel.fromJson({
        'id': 2,
        'title': 'Movie Two',
        'overview': 'Overview two',
      });

      expect(model.posterPath, isNull);
      expect(model.backdropPath, isNull);
    });
  });

  group('toJson', () {
    test('serializes correctly', () {
      const model = MovieResponseModel(
        id: 1,
        title: 'Movie One',
        overview: 'Overview one',
        posterPath: '/poster1.jpg',
        backdropPath: '/backdrop1.jpg',
      );

      expect(MovieResponseModel.toJson(model.toEntity()), movieJson);
    });
  });

  group('toEntity', () {
    test('converts to Movie entity with same values', () {
      final entity = MovieResponseModel.fromJson(movieJson).toEntity();

      expect(entity, isA<Movie>());
      expect(entity.id, 1);
      expect(entity.title, 'Movie One');
      expect(entity.overview, 'Overview one');
      expect(entity.posterPath, '/poster1.jpg');
      expect(entity.backdropPath, '/backdrop1.jpg');
    });
  });
}
