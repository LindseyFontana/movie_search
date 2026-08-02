import 'package:movie_search/data/data_source/remote/movie_data_source.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/domain/repository/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MovieDataSource _datasource;

  const MoviesRepositoryImpl(this._datasource);

  @override
  Future<TrendingMovies> getTrendingMovies() => _datasource.getTrendingMovies();
}
