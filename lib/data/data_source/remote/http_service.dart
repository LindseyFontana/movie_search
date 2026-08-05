import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_search/core/errors.dart';

class HttpService {
  final dio = Dio();

  Future<Response<dynamic>> request({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      final httpError = HttpError(
        statusCode: error.response?.statusCode,
        message: error.response?.statusMessage,
        stackTrace: error.stackTrace,
      );

      debugPrint(httpError.toString());

      throw httpError;
    } catch (error) {
      final httpError = HttpError(
        statusCode: 520,
        message: "Server Returned an Unknown Error",
      );

      debugPrint(httpError.toString());

      throw httpError;
    }
  }
}
