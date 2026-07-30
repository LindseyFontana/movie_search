import 'package:dio/dio.dart';
import 'package:movie_search/data/data_sources/remote/http_service.dart';

class MovieDataSource {
  const MovieDataSource(this.httpService);
  final HttpService httpService;

  static const _baseURL = "https://api.themoviedb.org/3/";

  getTrendingMovies() {
    httpService.request(
      path: "$_baseURL/trending/movie/day",
      queryParameters: {"language": "pt-BR"},
      options: Options(
        headers: {
          "accept": "application/json",
          // "Authorization": "Bearer $_token",
        },
      ),
    );
  }
}
