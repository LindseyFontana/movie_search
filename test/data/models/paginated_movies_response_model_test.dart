import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/models/paginated_movies_response_model.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

void main() {
  const paginationValues = {'page': 1, 'total_pages': 1};

  final paginatedMoviesJson = {
    'page': 2,
    'total_pages': 50,
    'results': [
      {
        'id': 10,
        'title': 'Movie Ten',
        'overview': 'Overview ten',
        'poster_path': '/poster10.jpg',
        'backdrop_path': '/backdrop10.jpg',
      },
    ],
  };

  group('fromJson', () {
    test('maps all attributes correctly', () {
      final model = PaginatedMoviesResponseModel.fromJson(paginatedMoviesJson);

      expect(model.page, 2);
      expect(model.totalPages, 50);
      expect(model.movies, hasLength(1));
      expect(model.movies.first.id, 10);
      expect(model.movies.first.title, 'Movie Ten');
      expect(model.movies.first.overview, 'Overview ten');
      expect(model.movies.first.posterPath, '/poster10.jpg');
      expect(model.movies.first.backdropPath, '/backdrop10.jpg');
    });

    test('filters out movies with empty title or overview', () {
      final model = PaginatedMoviesResponseModel.fromJson({
        ...paginationValues,
        'results': [
          {'id': 1, 'title': '', 'overview': 'Overview one'},
          {'id': 2, 'title': 'Movie Two', 'overview': ''},
          {'id': 3, 'title': 'Movie Three', 'overview': 'Overview three'},
        ],
      });

      expect(model.movies, hasLength(1));
      expect(model.movies.single.id, 3);
    });

    test('returns empty movies list when results is empty', () {
      final model = PaginatedMoviesResponseModel.fromJson({
        ...paginationValues,
        'results': <Map<String, dynamic>>[],
      });

      expect(model.movies, isEmpty);
    });

    test('returns empty movies list when results is null', () {
      final model = PaginatedMoviesResponseModel.fromJson(paginationValues);

      expect(model.movies, isEmpty);
    });

    test('returns empty movies list when results is not a list', () {
      final model = PaginatedMoviesResponseModel.fromJson({
        ...paginationValues,
        'results': 'invalid',
      });

      expect(model.movies, isEmpty);
    });
  });

  group('toJson', () {
    test('serializes correctly', () {
      final entity = PaginatedMoviesResponseModel.fromJson(
        paginatedMoviesJson,
      ).toEntity();

      expect(
        PaginatedMoviesResponseModel.toJson(entity),
        equals(paginatedMoviesJson),
      );
    });
  });

  group('toEntity', () {
    test('converts to PaginatedMovies entity with same values', () {
      final entity = PaginatedMoviesResponseModel.fromJson(
        paginatedMoviesJson,
      ).toEntity();

      expect(entity, isA<PaginatedMovies>());
      expect(entity.page, 2);
      expect(entity.totalPages, 50);
      expect(entity.movies, hasLength(1));
      expect(entity.movies.first.id, 10);
    });
  });
}
