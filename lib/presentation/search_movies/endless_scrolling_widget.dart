import 'package:flutter/material.dart';
import 'package:movie_search/domain/entities/trending_movies.dart';
import 'package:movie_search/main.dart';
import 'package:movie_search/presentation/search_movies/bloc/search_movies_bloc.dart';

class EndlessScrolling extends StatefulWidget {
  const EndlessScrolling({super.key, required this.trendingMovies});

  final TrendingMovies trendingMovies;

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
      bloc.add(LoadMoreTrendingMoviesEvent(bloc.state.trendingMovies));
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.trendingMovies.movies;

    return Expanded(
      child: ListView.separated(
        controller: _scrollControler,
        physics: ClampingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(movies[index].title);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
