import 'package:flutter/material.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';
import 'package:movie_search/main.dart';
import 'package:movie_search/presentation/screens/search_movies/bloc/search_movies_bloc.dart';

class EndlessScrolling extends StatefulWidget {
  const EndlessScrolling({super.key, required this.paginatedMovies});

  final PaginetedMovies paginatedMovies;

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
              return _buildMoviePoster(
                title: movies[index].title,
                url: movies[index].posterPath,
              );
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

  Widget _buildMoviePoster({required String title, String? url}) {
    return url != null && url.isNotEmpty
        ? Image.network(
            url,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              //TODO: habilitar quando salvar imagens em cache, irá recuperá-las
              // if (wasSynchronouslyLoaded) return child;
              if (frame != null) return child;

              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 59, 58, 58),
                ),
              );
            },
          )
        : _buildDefault(title);
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
