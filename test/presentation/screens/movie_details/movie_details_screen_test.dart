import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/di/dependency_injection.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/presentation/screens/movie_details/movie_details_screen.dart';
import 'package:movie_search/presentation/screens/widgets/back_button_widget.dart';

import '../../../mocks.dart';

void main() {
  late MockCacheManager cacheManager;

  const movieWithImages = Movie(
    id: 1,
    title: 'Movie One',
    overview: 'Overview one',
    posterPath: '/poster1.jpg',
    backdropPath: '/backdrop1.jpg',
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

  testWidgets('renders the screen with title, overview and movie images', (
    tester,
  ) async {
    cacheManager.getFileStreamOverride = pendingStream;

    await tester.pumpWidget(
      MaterialApp(home: MovieDetailsScreen(movieWithImages)),
    );

    expect(find.text('Movie One'), findsOneWidget);
    expect(find.text('Overview one'), findsOneWidget);
    expect(find.byType(BackButtonWidget), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNWidgets(2));
  });
}
