import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/domain/entities/movie.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/domain/entities/search_params.dart';
import 'package:movie_search/domain/usecases/get_trending_movies_use_case.dart';
import 'package:movie_search/domain/usecases/search_movies_use_case.dart';
import 'package:movie_search/presentation/screens/movies_search/bloc/movies_search_bloc.dart';

class MockGetTrendingMoviesUseCase extends Mock
    implements GetTrendingMoviesUseCase {}

class MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}

void main() {
  late MockGetTrendingMoviesUseCase getTrendingMoviesUseCase;
  late MockSearchMoviesUseCase searchMoviesUseCase;
  late MoviesSearchBloc bloc;

  const firstPageMovies = PaginatedMovies(
    page: 1,
    totalPages: 3,
    movies: [
      Movie(id: 1, title: 'Movie One', overview: 'Overview one'),
      Movie(id: 2, title: 'Movie Two', overview: 'Overview two'),
    ],
  );

  const secondPageMovies = PaginatedMovies(
    page: 2,
    totalPages: 3,
    movies: [Movie(id: 3, title: 'Movie Three', overview: 'Overview three')],
  );

  const mergedMovies = PaginatedMovies(
    page: 2,
    totalPages: 3,
    movies: [
      Movie(id: 1, title: 'Movie One', overview: 'Overview one'),
      Movie(id: 2, title: 'Movie Two', overview: 'Overview two'),
      Movie(id: 3, title: 'Movie Three', overview: 'Overview three'),
    ],
  );

  const apiError = HttpError(message: 'api error', statusCode: 500);

  const query = 'query';

  const searchFirstPageParams = SearchParams(query: query, pageToSearch: 1);

  const searchNextPageParams = SearchParams(query: query, pageToSearch: 2);

  const freshMovies = PaginatedMovies(
    page: 1,
    totalPages: 3,
    movies: [Movie(id: 4, title: 'Movie Four', overview: 'Overview four')],
  );

  setUp(() {
    getTrendingMoviesUseCase = MockGetTrendingMoviesUseCase();
    searchMoviesUseCase = MockSearchMoviesUseCase();

    when(
      () => getTrendingMoviesUseCase.trendingUpdates,
    ).thenAnswer((_) => Stream<PaginatedMovies>.empty());

    bloc = MoviesSearchBloc(getTrendingMoviesUseCase, searchMoviesUseCase);
  });

  group('GetTrendingMoviesEvent', () {
    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingState, SuccessState] when trending movies are fetched',
      setUp: () {
        when(() => getTrendingMoviesUseCase.call(1)).thenAnswer(
          (_) async => const Right<Failure, PaginatedMovies>(firstPageMovies),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTrendingMoviesEvent()),
      expect: () => [
        const LoadingState(),
        const SuccessState(paginatedMovies: firstPageMovies),
      ],
      verify: (_) => verify(() => getTrendingMoviesUseCase.call(1)).called(1),
    );

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingState, ErrorState] when fetching fails',
      setUp: () {
        when(() => getTrendingMoviesUseCase.call(1)).thenAnswer(
          (_) async => const Left<Failure, PaginatedMovies>(apiError),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTrendingMoviesEvent()),
      expect: () => [const LoadingState(), const ErrorState(apiError)],
    );
  });

  group('TrendingMoviesRefreshedEvent', () {
    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits SuccessState with fresh movies when on first trending page',
      seed: () => const SuccessState(paginatedMovies: firstPageMovies),
      build: () => bloc,
      act: (bloc) => bloc.add(TrendingMoviesRefreshedEvent(freshMovies)),
      expect: () => [const SuccessState(paginatedMovies: freshMovies)],
    );

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'ignores refresh when on a page after the first trending page',
      seed: () => const SuccessState(paginatedMovies: mergedMovies),
      build: () => bloc,
      act: (bloc) => bloc.add(TrendingMoviesRefreshedEvent(freshMovies)),
      expect: () => [],
    );

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'ignores refresh when a search query is active',
      seed: () => const SuccessState(
        paginatedMovies: firstPageMovies,
        query: query,
      ),
      build: () => bloc,
      act: (bloc) => bloc.add(TrendingMoviesRefreshedEvent(freshMovies)),
      expect: () => [],
    );
  });

  group('LoadMoreTrendingMoviesEvent', () {
    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingMoreMoviesState, SuccessState] when next page is loaded',
      setUp: () {
        when(() => getTrendingMoviesUseCase.call(2)).thenAnswer(
          (_) async => const Right<Failure, PaginatedMovies>(secondPageMovies),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(LoadMoreTrendingMoviesEvent(firstPageMovies)),
      expect: () => [
        const LoadingMoreMoviesState(paginatedMovies: firstPageMovies),
        const SuccessState(paginatedMovies: mergedMovies),
      ],
      verify: (_) => verify(() => getTrendingMoviesUseCase.call(2)).called(1),
    );

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingMoreMoviesState, ErrorState] when loading fails',
      setUp: () {
        when(() => getTrendingMoviesUseCase.call(2)).thenAnswer(
          (_) async => const Left<Failure, PaginatedMovies>(apiError),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(LoadMoreTrendingMoviesEvent(firstPageMovies)),
      expect: () => [
        const LoadingMoreMoviesState(paginatedMovies: firstPageMovies),
        const ErrorState(apiError),
      ],
    );
  });

  group('SearchMoviesEvent', () {
    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingState, SuccessState] when search succeeds',
      setUp: () {
        when(() => searchMoviesUseCase.call(searchFirstPageParams)).thenAnswer(
          (_) async => const Right<Failure, PaginatedMovies>(firstPageMovies),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(SearchMoviesEvent(query)),
      expect: () => [
        const LoadingState(),
        const SuccessState(paginatedMovies: firstPageMovies, query: query),
      ],
      verify: (_) => verify(() => searchMoviesUseCase.call(searchFirstPageParams)).called(1),
    );

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingState, ErrorState] when search fails',
      setUp: () {
        when(() => searchMoviesUseCase.call(searchFirstPageParams)).thenAnswer(
          (_) async => const Left<Failure, PaginatedMovies>(apiError),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(SearchMoviesEvent(query)),
      expect: () => [const LoadingState(), const ErrorState(apiError)],
    );
  });

  group('Trending revalidation', () {
    late StreamController<PaginatedMovies> controller;

    setUp(() {
      getTrendingMoviesUseCase = MockGetTrendingMoviesUseCase();
      searchMoviesUseCase = MockSearchMoviesUseCase();
      controller = StreamController<PaginatedMovies>.broadcast();

      when(
        () => getTrendingMoviesUseCase.trendingUpdates,
      ).thenAnswer((_) => controller.stream);

      when(() => getTrendingMoviesUseCase.call(1)).thenAnswer(
        (_) async => const Right<Failure, PaginatedMovies>(firstPageMovies),
      );

      bloc = MoviesSearchBloc(getTrendingMoviesUseCase, searchMoviesUseCase);
    });

    tearDown(() async {
      await controller.close();
    });

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits SuccessState with fresh movies when refresh is pushed on first page',
      build: () => bloc,
      act: (bloc) async {
        bloc.add(GetTrendingMoviesEvent());
        await bloc.stream.firstWhere((state) => state is SuccessState);
        controller.add(freshMovies);
      },
      expect: () => [
        const LoadingState(),
        const SuccessState(paginatedMovies: firstPageMovies),
        const SuccessState(paginatedMovies: freshMovies),
      ],
    );

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'ignores refresh when more pages have been loaded',
      setUp: () {
        when(() => getTrendingMoviesUseCase.call(2)).thenAnswer(
          (_) async => const Right<Failure, PaginatedMovies>(secondPageMovies),
        );
      },
      build: () => bloc,
      act: (bloc) async {
        bloc.add(GetTrendingMoviesEvent());
        await bloc.stream.firstWhere((state) => state is SuccessState);
        bloc.add(LoadMoreTrendingMoviesEvent(firstPageMovies));
        await bloc.stream.firstWhere(
          (state) => state.paginatedMovies?.page == 2,
        );
        controller.add(freshMovies);
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => [
        const LoadingState(),
        const SuccessState(paginatedMovies: firstPageMovies),
        const LoadingMoreMoviesState(paginatedMovies: firstPageMovies),
        const SuccessState(paginatedMovies: mergedMovies),
      ],
    );
  });

  group('SearchMoreMoviesEvent', () {
    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingMoreMoviesState, SuccessState] when next search page loads',
      setUp: () {
        when(() => searchMoviesUseCase.call(searchNextPageParams)).thenAnswer(
          (_) async => const Right<Failure, PaginatedMovies>(secondPageMovies),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(SearchMoreMoviesEvent(query, firstPageMovies)),
      expect: () => [
        const LoadingMoreMoviesState(
          paginatedMovies: firstPageMovies,
          query: query,
        ),
        const SuccessState(paginatedMovies: mergedMovies, query: query),
      ],
      verify: (_) => verify(() => searchMoviesUseCase.call(searchNextPageParams)).called(1),
    );

    blocTest<MoviesSearchBloc, MoviesSearchState>(
      'emits [LoadingMoreMoviesState, ErrorState] when loading fails',
      setUp: () {
        when(() => searchMoviesUseCase.call(searchNextPageParams)).thenAnswer(
          (_) async => const Left<Failure, PaginatedMovies>(apiError),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(SearchMoreMoviesEvent(query, firstPageMovies)),
      expect: () => [
        const LoadingMoreMoviesState(
          paginatedMovies: firstPageMovies,
          query: query,
        ),
        const ErrorState(apiError),
      ],
    );
  });
}
