import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/models/movie_response_model.dart';
import 'package:movie_search/domain/entities/movie.dart';

void main() {
  const Map<String, dynamic> movieJson = {
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
      expect(model.title, movieJson['title']);
      expect(model.overview, movieJson['overview']);
      expect(model.posterPath, movieJson['poster_path']);
      expect(model.backdropPath, movieJson['backdrop_path']);
    });

    test('maps missing poster and backdrop paths to null', () {
      final model = MovieResponseModel.fromJson({
        'id': 2,
        'title': movieJson['title'],
        'overview': movieJson['overview'],
      });

      expect(model.posterPath, isNull);
      expect(model.backdropPath, isNull);
    });
  });

  test('toJson: serializes correctly', () {
    final model = MovieResponseModel(
      id: 1,
      title: movieJson['title'],
      overview: movieJson['overview'],
      posterPath: movieJson['poster_path'],
      backdropPath: movieJson['backdrop_path'],
    );

    expect(MovieResponseModel.toJson(model.toEntity()), movieJson);
  });

  test('toEntity: converts to Movie entity with same values', () {
    final entity = MovieResponseModel.fromJson(movieJson).toEntity();

    expect(entity, isA<Movie>());
    expect(entity.id, 1);
    expect(entity.overview, movieJson['overview']);
    expect(entity.posterPath, movieJson['poster_path']);
    expect(entity.backdropPath, movieJson['backdrop_path']);
  });
}
