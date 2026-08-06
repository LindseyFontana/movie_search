import 'package:dio/dio.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/models/paginated_movies_response_model.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';

abstract class MovieDataSource {
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch);

  Future<PaginetedMovies> searchMovies(String query, int pageToSearch);
}

class MovieDataSourceImpl implements MovieDataSource {
  final HttpService httpService;

  const MovieDataSourceImpl(this.httpService);

  static const _baseURL = "https://api.themoviedb.org/3";

  static const _token = String.fromEnvironment("MOVIE_API_KEY");

  static const _defaultParameters = {
    "language": "pt-BR",
    "include_adult": false,
  };

  @override
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch) async {
    final response = await httpService.request(
      path: "$_baseURL/trending/movie/week",
      queryParameters: {..._defaultParameters, "page": pageToSearch},
      options: Options(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      ),
    );

    final json = response.data as Map<String, dynamic>;

    return PaginetedMoviesResponseModel.fromJson(json);
  }

  @override
  Future<PaginetedMovies> searchMovies(String query, int pageToSearch) async {
    final response = await httpService.request(
      path: "$_baseURL/search/movie",
      queryParameters: {
        ..._defaultParameters,
        "page": pageToSearch,
        "query": query,
      },
      options: Options(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      ),
    );

    final json = response.data as Map<String, dynamic>;

    return PaginetedMoviesResponseModel.fromJson(json);
  }
}
