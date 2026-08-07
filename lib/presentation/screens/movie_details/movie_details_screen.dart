import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/di/dependency_injection.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/extensions/movie_extension.dart';
import 'package:movie_search/presentation/screens/widgets/back_button_widget.dart';
import 'package:movie_search/presentation/screens/widgets/default_text.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    final textStyle = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                _buildMovieImage(
                  size: AppStrings.imageSizes.backDrop,
                  loaderHeight: mediaQuery.height / 4,
                  loaderWidth: mediaQuery.width,
                  path: movie.backdropPath,
                ),
                Padding(
                  padding: EdgeInsets.all(AppSizes.padding.smallest),
                  child: BackButtonWidget(hasShadow: true),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(AppSizes.padding.medium),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle.titleLarge,
                        ),
                      ),

                      Flexible(
                        flex: 1,
                        child: _buildMovieImage(
                          loaderHeight: 150,
                          loaderWidth: 100,
                          size: AppStrings.imageSizes.posterSmall,
                          path: movie.posterPath,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spacing.medium),
                  Text(movie.overview, style: textStyle.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieImage({
    required String size,
    String? path,
    required double loaderHeight,
    required double loaderWidth,
  }) {
    final url = movie.getImageUrl(size: size, path: path);

    return url != null && url.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: url,
            cacheManager: CustomCacheManager.instance,
            placeholder: (context, url) => Container(
              height: loaderHeight,
              width: loaderWidth,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 59, 58, 58),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : DefaultText(movie.title, height: loaderHeight, width: loaderWidth);
  }
}
