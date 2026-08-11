import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';

import '../../../mocks.dart';

void main() {
  late MockDio dio;
  late HttpService httpService;

  const path = 'https://api.themoviedb.org/3/trending/movie/week';

  setUp(() {
    dio = MockDio();
    httpService = HttpService(dio: dio);
  });

  void stubGet(Response<dynamic>? response, {DioException? error}) {
    when(
      () => dio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async {
      if (error != null) {
        throw error;
      }
      return response!;
    });
  }

  Response<dynamic> buildResponse({
    Map<String, dynamic>? data,
    int? statusCode,
  }) {
    return Response<dynamic>(
      data: data,
      statusCode: statusCode,
      requestOptions: RequestOptions(path: path),
    );
  }

  DioException buildDioException(
    DioExceptionType type, {
    Response<dynamic>? response,
  }) {
    return DioException(
      requestOptions: RequestOptions(path: path),
      type: type,
      response: response,
      message: 'dio error message',
    );
  }

  group('request', () {
    const statusCode = 200;

    const data = {'page': 1, 'total_pages': 10};

    final response = buildResponse(data: data, statusCode: statusCode);

    setUp(() => stubGet(response));

    test('verify if dio.get is called', () async {
      final options = Options(headers: {'x-test': 'true'});

      await httpService.request(
        path: path,
        queryParameters: {'page': 1},
        options: options,
      );

      verify(
        () => dio.get(path, queryParameters: {'page': 1}, options: options),
      ).called(1);
    });

    test('returns the Dio response on success', () async {
      final result = await httpService.request(path: path);

      expect(result, same(response));
      expect(result.statusCode, statusCode);
      expect(result.data, data);
    });
  });

  group('error mapping', () {
    test('throws ConnectionError on connectionError', () async {
      stubGet(null, error: buildDioException(DioExceptionType.connectionError));

      await expectLater(
        httpService.request(path: path),
        throwsA(
          isA<ConnectionError>().having(
            (e) => e.type,
            'type',
            ErrorType.connection,
          ),
        ),
      );
    });

    test('throws HttpError on connectionTimeout', () async {
      stubGet(
        null,
        error: buildDioException(DioExceptionType.connectionTimeout),
      );

      await expectLater(
        httpService.request(path: path),
        throwsA(isA<HttpError>()),
      );
    });

    test('throws HttpError on sendTimeout', () async {
      stubGet(null, error: buildDioException(DioExceptionType.sendTimeout));

      await expectLater(
        httpService.request(path: path),
        throwsA(isA<HttpError>()),
      );
    });

    test('throws HttpError on receiveTimeout', () async {
      stubGet(null, error: buildDioException(DioExceptionType.receiveTimeout));

      await expectLater(
        httpService.request(path: path),
        throwsA(isA<HttpError>()),
      );
    });

    test(
      'throws HttpError with statusCode and message on badResponse',
      () async {
        final errorResponse = Response<dynamic>(
          data: null,
          statusCode: 404,
          statusMessage: 'Not Found',
          requestOptions: RequestOptions(path: path),
        );
        stubGet(
          null,
          error: buildDioException(
            DioExceptionType.badResponse,
            response: errorResponse,
          ),
        );

        await expectLater(
          httpService.request(path: path),
          throwsA(
            isA<HttpError>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.message, 'message', 'Not Found')
                .having((e) => e.type, 'type', ErrorType.api),
          ),
        );
      },
    );

    test('throws GenericError on unknown errors', () async {
      when(
        () => dio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(StateError('boom'));

      await expectLater(
        httpService.request(path: path),
        throwsA(isA<GenericError>()),
      );
    });
  });
}
