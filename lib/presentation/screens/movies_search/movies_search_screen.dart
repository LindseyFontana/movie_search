import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/di/dependecy_injection.dart';
import 'package:movie_search/presentation/screens/credits/credits_screen.dart';
import 'package:movie_search/presentation/screens/movie_details/movie_details_screen.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';
import 'package:movie_search/presentation/screens/widgets/custom_error_widget.dart';
import 'package:movie_search/presentation/screens/widgets/endless_scrolling_widget.dart';

class MoviesSearchScreen extends StatefulWidget {
  const MoviesSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<MoviesSearchScreen> {
  final TextEditingController _inputTextController = TextEditingController();

  final bloc = getIt<MoviesSearchBloc>();

  final title = ValueNotifier<String>(AppStrings.movieSearch.trendingTitle);

  @override
  void initState() {
    bloc.add(GetTrendingMoviesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.title),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 16),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/credits'),
                  customBorder: const CircleBorder(),
                  child: Text(
                    AppStrings.movieSearch.ellipsis,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _inputTextController,
                  decoration: InputDecoration(
                    labelText: AppStrings.movieSearch.labelText,
                    hintText: AppStrings.movieSearch.hintText,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _inputTextController.text = "";
                        title.value = AppStrings.movieSearch.trendingTitle;

                        bloc.add(GetTrendingMoviesEvent());

                        FocusScope.of(context).unfocus();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (query) {
                    title.value = AppStrings.movieSearch.searchTitle;

                    bloc.add(MoviesSearchEvent(query));
                  },
                ),

                SizedBox(height: 24),

                ValueListenableBuilder<String>(
                  valueListenable: title,
                  builder: (context, value, child) {
                    return Text(title.value);
                  },
                ),

                SizedBox(height: 24),

                BlocBuilder<MoviesSearchBloc, MoviesSearchState>(
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

  Widget _buildBody(MoviesSearchState state) {
    final paginetedMovies = state.paginetedMovies;

    if (state is SuccessState || state is LoadingMoreMoviesState) {
      return paginetedMovies != null && paginetedMovies.movies.isNotEmpty
          ? EndlessScrolling(
              paginatedMovies: paginetedMovies,
              itemBuilder: _buildMoviePoster,
              itemCount: paginetedMovies.movies.length,
              isLoading: bloc.state is LoadingMoreMoviesState,
              loadMoreItems: () {
                final isSearchingMovies =
                    bloc.state.query != null && bloc.state.query!.isNotEmpty;

                if (paginetedMovies.page < paginetedMovies.totalPages) {
                  if (isSearchingMovies) {
                    bloc.add(
                      SearchMoreMoviesEvent(
                        bloc.state.query!,
                        bloc.state.paginetedMovies,
                      ),
                    );
                  } else {
                    bloc.add(
                      LoadMoreTrendingMoviesEvent(bloc.state.paginetedMovies),
                    );
                  }
                }
              },
            )
          : Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text(AppStrings.movieSearch.emptyList),
            );
    }
    if (state is ErrorState) {
      return CustomErrorWidget(error: state.error);
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildMoviePoster(BuildContext context, int index) {
    final movies = bloc.state.paginetedMovies?.movies;
    final movie = movies?[index];
    if (movie == null) return SizedBox();

    final url = movie.getImageUrl(
      size: AppStrings.imageSizes.posterLarge,
      path: movie.posterPath,
    );

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/movie_details', arguments: movie),
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
