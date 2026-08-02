import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/main.dart';
import 'package:movie_search/presentation/search_movies/bloc/search_movies_bloc.dart';

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
            if (state is SuccessState) {
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
                    SizedBox(height: 32),
                    Expanded(
                      child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        itemCount: state.trendingMovies.movies.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(state.trendingMovies.movies[index].title);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    ),
                    SizedBox(height: 32),
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
