import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/domain/entities/paginated_movies.dart';
import 'package:movie_search/presentation/screens/widgets/endless_scrolling_widget.dart';

void main() {
  const paginatedMovies = PaginatedMovies(page: 1, totalPages: 5, movies: []);

  Widget buildWidget({
    required int itemCount,
    required bool isLoading,
    required VoidCallback loadMoreItems,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: EndlessScrolling(
          paginatedMovies: paginatedMovies,
          itemCount: itemCount,
          isLoading: isLoading,
          loadMoreItems: loadMoreItems,
          itemBuilder: (context, index) => Text('Item $index'),
        ),
      ),
    );
  }

  testWidgets('renders the given number of items in the grid', (tester) async {
    const itemCount = 3;

    await tester.pumpWidget(
      buildWidget(itemCount: itemCount, isLoading: false, loadMoreItems: () {}),
    );

    final gridView = tester.widget<GridView>(find.byType(GridView));
    expect(gridView.childrenDelegate.estimatedChildCount, itemCount);
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
  });

  testWidgets('shows CircularProgressIndicator when isLoading is true',
      (tester) async {
    await tester.pumpWidget(
      buildWidget(itemCount: 1, isLoading: true, loadMoreItems: () {}),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('does not show CircularProgressIndicator when isLoading is false',
      (tester) async {
    await tester.pumpWidget(
      buildWidget(itemCount: 1, isLoading: false, loadMoreItems: () {}),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('calls loadMoreItems when scrolled to the bottom', (tester) async {
    var loadMoreCalls = 0;

    await tester.pumpWidget(
      buildWidget(
        itemCount: 30,
        isLoading: false,
        loadMoreItems: () => loadMoreCalls++,
      ),
    );

    await tester.drag(find.byType(GridView), const Offset(0, -5000));
    await tester.pump();

    expect(loadMoreCalls, greaterThan(0));
  });

  testWidgets('does not call loadMoreItems when not scrolled enough',
      (tester) async {
    var loadMoreCalls = 0;

    await tester.pumpWidget(
      buildWidget(
        itemCount: 30,
        isLoading: false,
        loadMoreItems: () => loadMoreCalls++,
      ),
    );

    await tester.drag(find.byType(GridView), const Offset(0, -100));
    await tester.pump();

    expect(loadMoreCalls, 0);
  });
}
