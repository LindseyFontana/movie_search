import 'package:dio/dio.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/models/trending_movies_model.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';

abstract class MovieDataSource {
  Future<TrendingMovies> getTrendingMovies(int pageToSearch);
}

class MovieDataSourceImpl implements MovieDataSource {
  final HttpService httpService;

  MovieDataSourceImpl(this.httpService);

  static const _baseURL = "https://api.themoviedb.org/3";

  @override
  Future<TrendingMovies> getTrendingMovies(int pageToSearch) async {
    const token = String.fromEnvironment("MOVIE_API_KEY");

    final response = await httpService.request(
      path: "$_baseURL/trending/movie/week",
      queryParameters: {"language": "pt-BR", "page": pageToSearch},
      options: Options(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    final json = response.data as Map<String, dynamic>;

    return TrendingMoviesModel.fromJson(json);
  }
}
