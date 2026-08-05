import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/main.dart';
import 'package:movie_search/presentation/screens/search_movies/bloc/search_movies_bloc.dart';
import 'package:movie_search/presentation/screens/widgets/custom_error_widget.dart';
import 'package:movie_search/presentation/screens/widgets/endless_scrolling_widget.dart';

class SearchMoviesScreen extends StatefulWidget {
  const SearchMoviesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<SearchMoviesScreen> {
  final TextEditingController _inputTextController = TextEditingController();

  final bloc = getIt<SearchMoviesBloc>();

  @override
  void initState() {
    bloc.add(GetTrendingMoviesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Center(child: Text('Filmes'))),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _inputTextController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar',
                    hintText: 'Digite o título do filme',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _inputTextController.text = "";
                        //TODO: salvar a primeira página em cache, talvez atualizar
                        //diariamente ou mensalmente para não perder a atualizadade da listagem
                        bloc.add(GetTrendingMoviesEvent());
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (query) => bloc.add(SearchMoviesEvent(query)),
                ),

                SizedBox(height: 32),

                BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
                  bloc: bloc,
                  builder: (context, state) =>
                      Expanded(child: _buildBody(state)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SearchMoviesState state) {
    final paginetedMovies = state.paginetedMovies;

    if (state is SuccessState || state is LoadingMoreMoviesState) {
      return paginetedMovies != null && paginetedMovies.movies.isNotEmpty
          ? EndlessScrolling(paginatedMovies: paginetedMovies)
          : Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text("Não há filmes"),
            );
    }
    if (state is ErrorState) {
      return CustomErrorWidget(error: state.error);
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
