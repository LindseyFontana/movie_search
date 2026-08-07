import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/domain/entities/pagineted_movies.dart';

class EndlessScrolling extends StatefulWidget {
  const EndlessScrolling({
    super.key,
    required this.paginatedMovies,
    required this.itemBuilder,
    required this.loadMoreItems,
    required this.itemCount,
    required this.isLoading,
  });

  final PaginetedMovies paginatedMovies;
  final Widget? Function(BuildContext, int) itemBuilder;
  final void Function() loadMoreItems;
  final bool isLoading;
  final int itemCount;

  @override
  State<StatefulWidget> createState() => _EndlessScrollingState();
}

class _EndlessScrollingState extends State<EndlessScrolling> {
  final _scrollControler = ScrollController();

  @override
  void initState() {
    _scrollControler.addListener(_onLoadMore);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControler.dispose();
    super.dispose();
  }

  void _onLoadMore() {
    if (!_scrollControler.hasClients) return;

    final scrollPosition = _scrollControler.offset;

    final maxScroll = _scrollControler.position.maxScrollExtent;

    final shouldLoadMoreItems = scrollPosition >= (maxScroll / 1.5);

    if (shouldLoadMoreItems) widget.loadMoreItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollControler,
            physics: ClampingScrollPhysics(),
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.67,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
          ),
        ),
        if (widget.isLoading) ...[
          CircularProgressIndicator(
            padding: EdgeInsets.only(top: AppSizes.padding.medium),
          ),
        ],
      ],
    );
  }
}
