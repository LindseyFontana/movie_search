import 'package:dio/dio.dart';
import 'package:movie_search/core/errors.dart';

class HttpService {
  static const _token = String.fromEnvironment('MOVIE_API_KEY');

  final Dio _dio;

  HttpService({Dio? dio})
    : _dio = dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              headers: {
                'accept': 'application/json',
                'Authorization': 'Bearer $_token',
              },
            ),
          );

  Future<Response<dynamic>> request({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          throw ConnectionError(
            message: error.toString(),
            stackTrace: error.stackTrace,
          );
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw HttpError(
            statusCode: error.response?.statusCode,
            message: error.message,
            stackTrace: error.stackTrace,
          );
        default:
          throw HttpError(
            statusCode: error.response?.statusCode,
            message: error.response?.statusMessage,
            stackTrace: error.stackTrace,
          );
      }
    } catch (error, stackTrace) {
      throw GenericError(
        message: error.toString(),
        stackTrace: stackTrace,
        type: ErrorType.api,
      );
    }
  }
}
