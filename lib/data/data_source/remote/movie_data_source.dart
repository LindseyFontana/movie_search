import 'package:dio/dio.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/models/paginated_movies_response_model.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';

abstract class MovieDataSource {
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch);

  Future<PaginetedMovies> searchMovies(String query, int pageToSearch);
}

class MovieDataSourceImpl implements MovieDataSource {
  final HttpService httpService;

  MovieDataSourceImpl(this.httpService);

  static const _baseURL = "https://api.themoviedb.org/3";
  static const _token = String.fromEnvironment("MOVIE_API_KEY");

  @override
  Future<PaginetedMovies> getTrendingMovies(int pageToSearch) async {
    final response = await httpService.request(
      path: "$_baseURL/trending/movie/week",
      queryParameters: {"language": "pt-BR", "page": pageToSearch},
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
      path: "$_baseURL/trending/movie/week",
      queryParameters: {"language": "pt-BR", "page": pageToSearch},
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
