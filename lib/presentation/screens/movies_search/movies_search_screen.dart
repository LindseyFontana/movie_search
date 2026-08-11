import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search/core/constants/app_keys.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';
import 'package:movie_search/presentation/screens/widgets/custom_app_bar.dart';
import 'package:movie_search/presentation/screens/widgets/custom_error_widget.dart';
import 'package:movie_search/presentation/screens/widgets/endless_scrolling_widget.dart';
import 'package:movie_search/presentation/screens/widgets/movie_image_widget.dart';

class MoviesSearchScreen extends StatefulWidget {
  const MoviesSearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<MoviesSearchScreen> {
  final TextEditingController _inputTextController = TextEditingController();
  late final MoviesSearchBloc bloc;

  @override
  void initState() {
    bloc = context.read<MoviesSearchBloc>();

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
    final textStyle = Theme.of(context).textTheme;

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
                    style: textStyle.titleLarge,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(AppSizes.padding.medium),
            child: Column(
              children: [
                TextField(
                  key: AppKeys.searchField,
                  controller: _inputTextController,
                  decoration: InputDecoration(
                    labelText: AppStrings.movieSearch.labelText,
                    hintText: AppStrings.movieSearch.hintText,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _inputTextController.text = "";

                        bloc.add(GetTrendingMoviesEvent());

                        FocusScope.of(context).unfocus();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (query) {
                    bloc.add(SearchMoviesEvent(query));
                  },
                ),

                SizedBox(height: AppSizes.spacing.medium),

                BlocBuilder<MoviesSearchBloc, MoviesSearchState>(
                  builder: (context, state) {
                    final isSearching =
                        state.query != null && state.query!.isNotEmpty;

                    final subtitle = isSearching
                        ? AppStrings.movieSearch.searchTitle
                        : AppStrings.movieSearch.trendingTitle;

                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(subtitle, style: textStyle.bodyLarge),
                          SizedBox(height: AppSizes.spacing.small),
                          Expanded(child: _buildBody(state)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(MoviesSearchState state) {
    final paginatedMovies = state.paginatedMovies;

    final textStyle = Theme.of(context).textTheme;

    if (state is SuccessState || state is LoadingMoreMoviesState) {
      return paginatedMovies != null && paginatedMovies.movies.isNotEmpty
          ? EndlessScrolling(
              key: AppKeys.movieGrid,
              paginatedMovies: paginatedMovies,
              itemBuilder: _buildMoviePoster,
              itemCount: paginatedMovies.movies.length,
              isLoading: bloc.state is LoadingMoreMoviesState,
              loadMoreItems: () {
                final isSearchingMovies =
                    bloc.state.query != null && bloc.state.query!.isNotEmpty;

                if (paginatedMovies.page < paginatedMovies.totalPages) {
                  if (isSearchingMovies) {
                    bloc.add(
                      SearchMoreMoviesEvent(
                        bloc.state.query!,
                        bloc.state.paginatedMovies,
                      ),
                    );
                  } else {
                    bloc.add(
                      LoadMoreTrendingMoviesEvent(bloc.state.paginatedMovies),
                    );
                  }
                }
              },
            )
          : Padding(
              padding: EdgeInsets.only(top: AppSizes.padding.large),
              child: Text(
                AppStrings.movieSearch.emptyList,
                key: AppKeys.emptyListMessage,
                style: textStyle.titleLarge,
              ),
            );
    }
    if (state is ErrorState) {
      return CustomErrorWidget(key: AppKeys.errorWidget, error: state.error);
    } else {
      return Center(
        child: CircularProgressIndicator(key: AppKeys.loadingIndicator),
      );
    }
  }

  Widget _buildMoviePoster(BuildContext context, int index) {
    final movies = context
        .read<MoviesSearchBloc>()
        .state
        .paginatedMovies
        ?.movies;
    final movie = movies?[index];
    if (movie == null) return SizedBox.shrink();

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppStrings.routes.movieDetails,
        arguments: movie,
      ),
      child: MovieImageWidget(
        movie: movie,
        path: movie.posterPath,
        size: AppStrings.imageSizes.posterLarge,
      ),
    );
  }
}
