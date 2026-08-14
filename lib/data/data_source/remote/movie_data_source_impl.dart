import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/data_source/remote/movie_data_source.dart';
import 'package:movie_search/data/models/paginated_movies_response_model.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';

class MovieDataSourceImpl implements MovieDataSource {
  final HttpService httpService;

  const MovieDataSourceImpl(this.httpService);

  static const _baseURL = "https://api.themoviedb.org/3";

  static const _defaultParameters = {
    "language": "pt-BR",
    "include_adult": false,
  };

  @override
  Future<PaginatedMovies> getTrendingMovies(int pageToSearch) async {
    final response = await httpService.request(
      path: "$_baseURL/trending/movie/day",
      queryParameters: {..._defaultParameters, "page": pageToSearch},
    );

    final json = response.data as Map<String, dynamic>;

    return PaginatedMoviesResponseModel.fromJson(json).toEntity();
  }

  @override
  Future<PaginatedMovies> searchMovies(String query, int pageToSearch) async {
    final response = await httpService.request(
      path: "$_baseURL/search/movie",
      queryParameters: {
        ..._defaultParameters,
        "page": pageToSearch,
        "query": query,
      },
    );

    final json = response.data as Map<String, dynamic>;

    return PaginatedMoviesResponseModel.fromJson(json).toEntity();
  }
}
