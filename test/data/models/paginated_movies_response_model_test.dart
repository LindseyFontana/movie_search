import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/models/paginated_movies_response_model.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

void main() {
  const paginationValues = {'page': 1, 'total_pages': 1};

  const page = 2;
  const totalPages = 50;
  const movieId = 10;
  const movieTitle = 'Movie Ten';
  const movieOverview = 'Overview ten';
  const moviePosterPath = '/poster10.jpg';
  const movieBackdropPath = '/backdrop10.jpg';

  const paginatedMoviesJson = {
    'page': page,
    'total_pages': totalPages,
    'results': [
      {
        'id': movieId,
        'title': movieTitle,
        'overview': movieOverview,
        'poster_path': moviePosterPath,
        'backdrop_path': movieBackdropPath,
      },
    ],
  };

  group('fromJson', () {
    test('maps all attributes correctly', () {
      final model = PaginatedMoviesResponseModel.fromJson(paginatedMoviesJson);

      expect(model.page, page);
      expect(model.totalPages, totalPages);
      expect(model.movies, hasLength(1));
      expect(model.movies.first.id, movieId);
      expect(model.movies.first.title, movieTitle);
      expect(model.movies.first.overview, movieOverview);
      expect(model.movies.first.posterPath, moviePosterPath);
      expect(model.movies.first.backdropPath, movieBackdropPath);
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

  test('toJson: serializes correctly', () {
    final entity = PaginatedMoviesResponseModel.fromJson(
      paginatedMoviesJson,
    ).toEntity();

    expect(
      PaginatedMoviesResponseModel.toJson(entity),
      equals(paginatedMoviesJson),
    );
  });

  test('toEntity: converts to PaginatedMovies entity with same values', () {
    final entity = PaginatedMoviesResponseModel.fromJson(
      paginatedMoviesJson,
    ).toEntity();

    expect(entity, isA<PaginatedMovies>());
    expect(entity.page, page);
    expect(entity.totalPages, totalPages);
    expect(entity.movies, hasLength(1));
    expect(entity.movies.first.id, movieId);
  });
}
