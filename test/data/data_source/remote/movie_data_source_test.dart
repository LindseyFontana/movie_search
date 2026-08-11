import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/data/data_source/remote/movie_data_source.dart';

import '../../../mocks.dart';

Response<dynamic> buildResponse(Map<String, dynamic> data) => Response<dynamic>(
  data: data,
  statusCode: 200,
  requestOptions: RequestOptions(path: ''),
);

void main() {
  late MockHttpService httpService;
  late MovieDataSourceImpl dataSource;

  const page = 5;
  const totalPage = 10;
  const queryParameters = {
    'language': 'pt-BR',
    'include_adult': false,
    'page': page,
  };

  setUp(() {
    httpService = MockHttpService();
    dataSource = MovieDataSourceImpl(httpService);
  });

  void stubRequest(Response<dynamic> response) {
    when(
      () => httpService.request(
        path: any(named: 'path'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => response);
  }

  group('getTrendingMovies', () {
    test('requests the trending movies endpoint with page', () async {
      stubRequest(
        buildResponse({'page': page, 'total_pages': totalPage, 'results': []}),
      );

      await dataSource.getTrendingMovies(page);

      verify(
        () => httpService.request(
          path: 'https://api.themoviedb.org/3/trending/movie/week',
          queryParameters: queryParameters,
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('returns PaginatedMovies with right values', () async {
      const title = 'Movie One';

      stubRequest(
        buildResponse({
          'page': page,
          'total_pages': totalPage,
          'results': [
            {
              'id': 1,
              'title': title,
              'overview': 'Overview one',
              'poster_path': '/poster1.jpg',
              'backdrop_path': '/backdrop1.jpg',
            },
          ],
        }),
      );

      final result = await dataSource.getTrendingMovies(page);

      expect(result.page, page);
      expect(result.totalPages, totalPage);
      expect(result.movies, hasLength(1));
      expect(result.movies.single.title, title);
    });
  });

  group('searchMovies', () {
    const title = 'title';
    const query = 'query';

    test('requests the search movies endpoint with query and page', () async {
      stubRequest(
        buildResponse({'page': page, 'total_pages': totalPage, 'results': []}),
      );

      await dataSource.searchMovies(query, page);

      verify(
        () => httpService.request(
          path: 'https://api.themoviedb.org/3/search/movie',
          queryParameters: {...queryParameters, 'query': query},
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('returns PaginatedMovies with right values', () async {
      stubRequest(
        buildResponse({
          'page': page,
          'total_pages': totalPage,
          'results': [
            {
              'id': 10,
              'title': title,
              'overview': 'A result',
              'poster_path': '/poster10.jpg',
              'backdrop_path': '/backdrop10.jpg',
            },
          ],
        }),
      );

      final result = await dataSource.searchMovies(query, page);

      expect(result.page, page);
      expect(result.totalPages, totalPage);
      expect(result.movies, hasLength(1));
      expect(result.movies.single.title, title);
    });
  });
}
