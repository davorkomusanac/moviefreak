import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/movies/popular_movies/popular_movies_cubit.dart';
import '../../../utilities/utilities.dart';
import 'popular_movies_card.dart';

class PopularMoviesGridView extends StatefulWidget {
  const PopularMoviesGridView({Key? key}) : super(key: key);

  @override
  State<PopularMoviesGridView> createState() => _PopularMoviesGridViewState();
}

class _PopularMoviesGridViewState extends State<PopularMoviesGridView> {
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

  int _calculatePopularMoviesItemCount(PopularMoviesState state) {
    if (state.popularPageNum < state.popularMovies.totalPages) {
      return state.popularMovies.movieSummaries.length + 1;
    } else {
      return state.popularMovies.movieSummaries.length;
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
        builder: (context, state) => state.status == PopularMoviesStatus.error
            ? BuildSearchErrorMessage(state.errorMessage)
            : NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                    context.read<PopularMoviesCubit>().popularMoviesNextPageCalled();
                  }
                  return false;
                },
                child: GridView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: _calculatePopularMoviesItemCount(state),
                  itemBuilder: (context, index) => index >= state.popularMovies.movieSummaries.length
                      ? const BuildLoaderNextPage()
                      : PopularMoviesCard(
                          movieSummary: state.popularMovies.movieSummaries[index],
                          key: ValueKey(
                            state.popularMovies.movieSummaries[index].id,
                          ),
                        ),
                ),
              ),
      );
}
