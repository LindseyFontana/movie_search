import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';
import 'package:movie_search/main.dart';
import 'package:movie_search/presentation/screens/movie_details/movie_details_screen.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';

class EndlessScrolling extends StatefulWidget {
  const EndlessScrolling({super.key, required this.paginatedMovies});

  final PaginetedMovies paginatedMovies;

  @override
  State<StatefulWidget> createState() => _EndlessScrollingState();
}

class _EndlessScrollingState extends State<EndlessScrolling> {
  final _scrollControler = ScrollController();
  final bloc = getIt<MoviesSearchBloc>();

  @override
  void initState() {
    _scrollControler.addListener(_loadMoreMovies);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControler.dispose();
    super.dispose();
  }

  void _loadMoreMovies() {
    if (_scrollControler.position.pixels >=
        (_scrollControler.position.maxScrollExtent -
            (_scrollControler.position.pixels / 1.5))) {
      final paginetedMovies = bloc.state.paginetedMovies;

      final isSearchingMovies =
          bloc.state.query != null && bloc.state.query!.isNotEmpty;

      if (paginetedMovies != null &&
          paginetedMovies.page < paginetedMovies.totalPages) {
        if (isSearchingMovies) {
          bloc.add(
            SearchMoreMoviesEvent(
              bloc.state.query!,
              bloc.state.paginetedMovies,
            ),
          );
        } else {
          bloc.add(LoadMoreTrendingMoviesEvent(bloc.state.paginetedMovies));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.paginatedMovies.movies;

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollControler,
            physics: ClampingScrollPhysics(),
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              //TODO: receber isso como atributo, para que EndlessScrolling seja reutilizável
              return _buildMoviePoster(context, movies[index]);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.67,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
          ),
        ),
        if (bloc.state is LoadingMoreMoviesState) ...[
          CircularProgressIndicator(padding: EdgeInsets.only(top: 16)),
        ],
      ],
    );
  }

  Widget _buildMoviePoster(BuildContext context, Movie movie) {
    final url = movie.getImageUrl(size: "w154", path: movie.posterPath);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie)),
      ),
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 59, 58, 58),
                ),
              ),
              cacheManager: CacheManager(
                Config(
                  'movies_app_cache_key',
                  maxNrOfCacheObjects: 30,
                  stalePeriod: const Duration(days: 5),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          : _buildDefault(movie.title),
    );
  }

  Widget _buildDefault(String title) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 59, 58, 58)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(title)),
        ),
      ),
    );
  }
}
