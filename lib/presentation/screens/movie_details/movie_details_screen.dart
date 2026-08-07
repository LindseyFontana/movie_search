import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/domain/entities/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                _buildMovieImage(
                  size: AppStrings.imageSizes.backDrop,
                  loaderHeight: mediaQuery.height / 4,
                  loaderWidget: mediaQuery.width,
                  path: movie.backdropPath,
                ),
                Padding(
                  padding: EdgeInsets.all(AppSizes.padding.smallest),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    customBorder: const CircleBorder(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(125, 125, 125, 0.63),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
                          style: TextStyle(fontSize: AppSizes.font.title),
                        ),
                      ),

                      Flexible(
                        flex: 1,
                        child: _buildMovieImage(
                          loaderHeight: 150,
                          loaderWidget: 100,
                          size: AppStrings.imageSizes.posterSmall,
                          path: movie.posterPath,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spacing.medium),
                  Text(
                    movie.overview,
                    style: TextStyle(fontSize: AppSizes.font.subtitle),
                  ),
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
    required double loaderWidget,
  }) {
    final url = movie.getImageUrl(size: size, path: path);

    return Image.network(
      url!,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        if (frame != null) return child;

        return Container(
          height: loaderHeight,
          width: loaderWidget,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 59, 58, 58),
          ),
        );
      },
    );
  }
}
