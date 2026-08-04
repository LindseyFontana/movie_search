import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/main.dart';
import 'package:movie_search/presentation/search_movies/bloc/search_movies_bloc.dart';
import 'package:movie_search/presentation/search_movies/widgets/endless_scrolling_widget.dart';

class SearchMoviesScreen extends StatefulWidget {
  const SearchMoviesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<SearchMoviesScreen> {
  final TextEditingController _myController = TextEditingController();

  final bloc = getIt<SearchMoviesBloc>();

  @override
  void initState() {
    bloc.add(GetTrendingMoviesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Filmes'))),
      body: SafeArea(
        child: BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
          bloc: bloc,
          builder: (context, state) {
            final trendingMovies = state.trendingMovies;

            if (state is SuccessState || state is LoadingMoreMoviesState) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _myController,
                      decoration: InputDecoration(
                        labelText: 'Pesquisar',
                        hintText: 'Digite o título do filme',
                        suffixIcon: Icon(Icons.clear),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    if (trendingMovies != null &&
                        trendingMovies.movies.isNotEmpty)
                      EndlessScrolling(trendingMovies: trendingMovies),
                    if (state is LoadingMoreMoviesState)
                      CircularProgressIndicator(),
                  ],
                ),
              );
            }
            if (state is ErrorState) {
              return Center(child: Text("Error"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
