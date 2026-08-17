import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/core/constants/app_keys.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';
import 'package:movie_search/presentation/screens/movies_search/movies_search_screen.dart';
import 'package:movie_search/presentation/screens/widgets/custom_error_widget.dart';
import 'package:movie_search/presentation/screens/widgets/endless_scrolling_widget.dart';

import '../../../mocks.dart';

void main() {
  late MockMoviesSearchBloc bloc;

  const firtMovie = 'Movie One';
  const secondMovie = 'Movie Two';

  const trendingMovies = PaginatedMovies(
    page: 1,
    totalPages: 3,
    movies: [
      Movie(id: 1, title: firtMovie, overview: 'Overview one'),
      Movie(id: 2, title: secondMovie, overview: 'Overview two'),
    ],
  );

  const emptyMovies = PaginatedMovies(page: 1, totalPages: 1, movies: []);

  final initialState = InitialState();

  setUp(() => bloc = MockMoviesSearchBloc());

  setUpAll(() {
    registerFallbackValue(GetTrendingMoviesEvent());
  });

  Future<void> pumpScreen(
    WidgetTester tester,
    MoviesSearchState state, {
    List<NavigatorObserver> navigatorObservers = const [],
  }) async {
    whenListen(bloc, Stream.fromIterable([state]), initialState: initialState);

    when(() => bloc.state).thenReturn(state);

    when(() => bloc.close()).thenAnswer((_) async {});

    await tester.pumpWidget(
      BlocProvider<MoviesSearchBloc>(
        create: (_) => bloc,
        child: MaterialApp(
          navigatorObservers: navigatorObservers,
          routes: {
            AppStrings.routes.movieDetails: (_) =>
                const Scaffold(body: Text('details')),
            AppStrings.routes.credits: (_) =>
                const Scaffold(body: Text('credits')),
          },
          home: const MoviesSearchScreen(),
        ),
      ),
    );
    await tester.pump();
  }

  group('when state is success', () {
    testWidgets('and has paginatedMovies with movies, renders the movie grid', (
      tester,
    ) async {
      await pumpScreen(tester, SuccessState(paginatedMovies: trendingMovies));

      expect(find.byType(EndlessScrolling), findsOneWidget);
      expect(find.byKey(AppKeys.movieGrid), findsOneWidget);
      expect(find.text(firtMovie), findsOneWidget);
      expect(find.text(secondMovie), findsOneWidget);
    });

    testWidgets(
      'and has paginatedMovies with empty list of movies, renders message',
      (tester) async {
        await pumpScreen(tester, SuccessState(paginatedMovies: emptyMovies));

        expect(find.byKey(AppKeys.emptyListMessage), findsOneWidget);
        expect(find.text('Filmes não encontrados'), findsOneWidget);
      },
    );
  });

  testWidgets('when state is loading, renders CircularProgressIndicator', (
    tester,
  ) async {
    await pumpScreen(tester, LoadingState());

    expect(find.byKey(AppKeys.loadingIndicator), findsOneWidget);
    expect(
      tester.widget<CircularProgressIndicator>(
        find.byKey(AppKeys.loadingIndicator),
      ),
      isA<CircularProgressIndicator>(),
    );
  });

  testWidgets(
    'when state is loading more movies keeps the grid and renders a loading indicator',
    (tester) async {
      await pumpScreen(
        tester,
        LoadingMoreMoviesState(paginatedMovies: trendingMovies),
      );

      expect(find.byType(EndlessScrolling), findsOneWidget);
      expect(find.text(firtMovie), findsOneWidget);
      expect(find.text(secondMovie), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(AppKeys.loadingIndicator), findsNothing);
    },
  );

  testWidgets('when state is error, renders CustomErrorWidget', (tester) async {
    await pumpScreen(
      tester,
      ErrorState(const HttpError(message: 'api error', statusCode: 500)),
    );

    expect(find.byKey(AppKeys.errorWidget), findsOneWidget);
    expect(find.byType(CustomErrorWidget), findsOneWidget);
  });

  testWidgets(
    'when state is error, pressing try again re-dispatches last event',
    (tester) async {
      await pumpScreen(
        tester,
        ErrorState(const HttpError(message: 'api error', statusCode: 500)),
      );

      await tester.tap(find.byKey(AppKeys.errorRetryButton));
      await tester.pump();

      verify(
        () => bloc.add(any(that: isA<GetTrendingMoviesEvent>())),
      ).called(2);
    },
  );

  group('LoadMoreTrendingMoviesEvent', () {
    List<Movie> buildMovies(int count) => List.generate(
      count,
      (index) =>
          Movie(id: index, title: 'Movie $index', overview: 'Overview $index'),
    );

    testWidgets(
      'dispatches LoadMoreTrendingMoviesEvent when scrolled to the bottom',
      (tester) async {
        await pumpScreen(
          tester,
          SuccessState(
            paginatedMovies: PaginatedMovies(
              page: 1,
              totalPages: 3,
              movies: buildMovies(30),
            ),
          ),
        );

        await tester.drag(
          find.byKey(AppKeys.movieGrid),
          const Offset(0, -5000),
        );
        await tester.pump();

        verify(
          () => bloc.add(any(that: isA<LoadMoreTrendingMoviesEvent>())),
        ).called(greaterThan(0));
      },
    );

    testWidgets(
      'does not dispatch LoadMoreTrendingMoviesEvent when on last page',
      (tester) async {
        await pumpScreen(
          tester,
          SuccessState(
            paginatedMovies: PaginatedMovies(
              page: 3,
              totalPages: 3,
              movies: buildMovies(30),
            ),
          ),
        );

        await tester.drag(
          find.byKey(AppKeys.movieGrid),
          const Offset(0, -5000),
        );
        await tester.pump();

        verifyNever(
          () => bloc.add(any(that: isA<LoadMoreTrendingMoviesEvent>())),
        );
      },
    );
  });

  group('SearchMoreMoviesEvent', () {
    List<Movie> buildMovies(int count) => List.generate(
      count,
      (index) =>
          Movie(id: index, title: 'Movie $index', overview: 'Overview $index'),
    );

    testWidgets(
      'dispatches SearchMoreMoviesEvent when scrolled to the bottom with active query',
      (tester) async {
        const query = 'matrix';

        await pumpScreen(
          tester,
          SuccessState(
            paginatedMovies: PaginatedMovies(
              page: 1,
              totalPages: 3,
              movies: buildMovies(30),
            ),
            query: query,
          ),
        );

        await tester.drag(
          find.byKey(AppKeys.movieGrid),
          const Offset(0, -5000),
        );
        await tester.pump();

        verify(
          () => bloc.add(any(that: isA<SearchMoreMoviesEvent>())),
        ).called(greaterThan(0));
      },
    );

    testWidgets('does not dispatch SearchMoreMoviesEvent when on last page', (
      tester,
    ) async {
      const query = 'matrix';

      await pumpScreen(
        tester,
        SuccessState(
          paginatedMovies: PaginatedMovies(
            page: 3,
            totalPages: 3,
            movies: buildMovies(30),
          ),
          query: query,
        ),
      );

      await tester.drag(find.byKey(AppKeys.movieGrid), const Offset(0, -5000));
      await tester.pump();

      verifyNever(() => bloc.add(any(that: isA<SearchMoreMoviesEvent>())));
    });
  });
}
