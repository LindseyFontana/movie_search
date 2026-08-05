import 'package:flutter/material.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/main.dart';
import 'package:movie_search/presentation/screens/search_movies/bloc/search_movies_bloc.dart';

class EndlessScrolling extends StatefulWidget {
  const EndlessScrolling({super.key, required this.trendingMovies});

  final PaginetedMovies trendingMovies;

  @override
  State<StatefulWidget> createState() => _EndlessScrollingState();
}

class _EndlessScrollingState extends State<EndlessScrolling> {
  final _scrollControler = ScrollController();
  final bloc = getIt<SearchMoviesBloc>();

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
      final trendingMovies = bloc.state.trendingMovies;

      if (trendingMovies != null && trendingMovies.page < 5) {
        bloc.add(LoadMoreTrendingMoviesEvent(bloc.state.trendingMovies));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.trendingMovies.movies;

    return Expanded(
      child: GridView.builder(
        controller: _scrollControler,
        physics: ClampingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            movies[index].posterPath,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              //TODO: habilitar quando salvar imagens em cache, irá recuperá-las
              // if (wasSynchronouslyLoaded) return child;
              if (frame != null) return child;

              return MoviePoster(
                title: movies[index].title,
                url: movies[index].posterPath,
              );
            },
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.67,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  const MoviePoster({super.key, required this.title, required this.url});

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 59, 58, 58)),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Text(title),
      ),
    );
  }
}
