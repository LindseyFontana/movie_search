import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/screens/widgets/back_button_widget.dart';
import 'package:movie_search/presentation/screens/widgets/movie_image_widget.dart';

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
                MovieImageWidget(
                  movie: movie,
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
                        child: MovieImageWidget(
                          movie: movie,
                          loaderHeight: 135,
                          loaderWidth: 90,
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
}
