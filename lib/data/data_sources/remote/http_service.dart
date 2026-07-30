import 'package:dio/dio.dart';

class HttpService {
  final dio = Dio();

  Future<Response<dynamic>> request({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
