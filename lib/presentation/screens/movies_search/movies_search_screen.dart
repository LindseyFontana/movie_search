import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/di/dependecy_injection.dart';
import 'package:movie_search/presentation/extensions/movie_extension.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';
import 'package:movie_search/presentation/screens/widgets/custom_app_bar.dart';
import 'package:movie_search/presentation/screens/widgets/custom_error_widget.dart';
import 'package:movie_search/presentation/screens/widgets/default_text.dart';
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
          appBar: CustomAppBar(
            title: AppStrings.title,
            actions: [
              InkWell(
                splashColor: Color.fromRGBO(125, 125, 125, 0.63),
                onTap: () =>
                    Navigator.pushNamed(context, AppStrings.routes.credits),
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  child: Text(
                    AppStrings.movieSearch.ellipsis,
                    style: TextStyle(fontSize: AppSizes.font.title),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(AppSizes.padding.medium),
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

                SizedBox(height: AppSizes.spacing.medium),

                ValueListenableBuilder<String>(
                  valueListenable: title,
                  builder: (context, value, child) {
                    return Text(
                      title.value,
                      style: TextStyle(fontSize: AppSizes.font.subtitle),
                    );
                  },
                ),

                SizedBox(height: AppSizes.spacing.small),

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
              padding: EdgeInsets.only(top: AppSizes.padding.large),
              child: Text(
                AppStrings.movieSearch.emptyList,
                style: TextStyle(fontSize: AppSizes.font.subtitle),
              ),
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
    if (movie == null) return SizedBox.shrink();

    final url = movie.getImageUrl(
      size: AppStrings.imageSizes.posterLarge,
      path: movie.posterPath,
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppStrings.routes.movieDetails,
        arguments: movie,
      ),
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 59, 58, 58),
                ),
              ),
              cacheManager: CustomCacheManager.instance,
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          : DefaultText(movie.title),
    );
  }
}
