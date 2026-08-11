import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/di/dependency_injection.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/extensions/movie_extension.dart';
import 'package:movie_search/presentation/screens/widgets/default_text.dart';

class MovieImageWidget extends StatelessWidget {
  const MovieImageWidget({
    super.key,
    required this.movie,
    required this.size,
    this.loaderHeight,
    this.loaderWidth,
    this.path,
  });

  final Movie movie;
  final String size;
  final String? path;
  final double? loaderHeight;
  final double? loaderWidth;

  @override
  Widget build(BuildContext context) {
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
