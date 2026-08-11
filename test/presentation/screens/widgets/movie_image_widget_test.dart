import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/di/dependency_injection.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/screens/widgets/default_text.dart';
import 'package:movie_search/presentation/screens/widgets/movie_image_widget.dart';

import '../../../mocks.dart';

void main() {
  late MockCacheManager cacheManager;

  const movieWithImage = Movie(
    id: 1,
    title: 'Movie One',
    overview: 'Overview one',
    posterPath: '/poster1.jpg',
  );

  const movieWithoutImage = Movie(
    id: 2,
    title: 'Movie Two',
    overview: 'Overview two',
  );

  setUp(() {
    cacheManager = MockCacheManager();
    CustomCacheManager.instance = cacheManager;
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  });

  Stream<FileResponse> pendingStream() {
    final controller = StreamController<FileResponse>();
    addTearDown(controller.close);
    return controller.stream;
  }

  Future<void> pumpWidget(WidgetTester tester, Movie movie) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieImageWidget(
            movie: movie,
            size: 'w92',
            loaderHeight: 150,
            loaderWidth: 100,
            path: movie.posterPath,
          ),
        ),
      ),
    );
  }

  testWidgets('renders CachedNetworkImage when url is not empty',
      (tester) async {
    cacheManager.getFileStreamOverride = pendingStream;

    await pumpWidget(tester, movieWithImage);

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('renders error icon when cached image fails to load',
      (tester) async {
    cacheManager.getFileStreamOverride = () =>
        Stream<FileResponse>.error(Exception('network error'));

    await pumpWidget(tester, movieWithImage);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('renders placeholder container while cached image is loading',
      (tester) async {
    cacheManager.getFileStreamOverride = pendingStream;

    await pumpWidget(tester, movieWithImage);

    final placeholderColor = const Color.fromARGB(255, 59, 58, 58);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == placeholderColor,
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.error), findsNothing);
  });

  testWidgets('renders DefaultText when url is empty', (tester) async {
    await pumpWidget(tester, movieWithoutImage);

    expect(find.byType(DefaultText), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });
}
