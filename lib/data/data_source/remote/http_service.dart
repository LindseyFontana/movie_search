import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:movie_search/core/errors.dart';

class HttpService {
  final dio = Dio();

  Future<Response<dynamic>> request({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    bool hasConnection = await InternetConnection().hasInternetAccess;

    if (!hasConnection) {
      throw ConnectionError(message: "Connection error");
    }

    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw HttpError(
        statusCode: error.response?.statusCode,
        message: error.response?.statusMessage,
        stackTrace: error.stackTrace,
      );
    } catch (error) {
      throw GenericError(message: "Generic error", type: ErrorType.api);
    }
  }
}
