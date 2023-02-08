import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/movies/movie_search/movie_search_cubit.dart';
import '../../../utilities/utilities.dart';
import 'movie_search_card.dart';

class MovieSearchResultsListView extends StatefulWidget {
  const MovieSearchResultsListView({Key? key}) : super(key: key);

  @override
  State<MovieSearchResultsListView> createState() => _MovieSearchResultsListViewState();
}

class _MovieSearchResultsListViewState extends State<MovieSearchResultsListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _calculateMovieListItemCount(MovieSearchState state) {
    if (state.searchPageNum < state.movieSearchResults.totalPages) {
      return state.movieSearchResults.movieSummaries.length + 1;
    } else {
      return state.movieSearchResults.movieSummaries.length;
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<MovieSearchCubit, MovieSearchState>(
        builder: (context, state) {
          switch (state.status) {
            case MovieSearchStatus.loading:
              return const BuildSearchProgressIndicator();
            case MovieSearchStatus.error:
              return BuildSearchErrorMessage(state.errorMessage);
            case MovieSearchStatus.success:
              //If at end of the Listview, search for more Results
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                    context.read<MovieSearchCubit>().nextSearchResultPageCalled();
                  }
                  return false;
                },
                child: ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  itemCount: _calculateMovieListItemCount(state),
                  itemBuilder: (context, index) => index >= state.movieSearchResults.movieSummaries.length
                      ? const BuildLoaderNextPage()
                      : MovieSearchCard(
                          movieSummary: state.movieSearchResults.movieSummaries[index],
                          key: ValueKey(
                            state.movieSearchResults.movieSummaries[index].id,
                          ),
                        ),
                ),
              );
          }
        },
      );
}
