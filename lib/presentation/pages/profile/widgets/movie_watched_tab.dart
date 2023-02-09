import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/user/user_watchlist_and_watched/user_watchlist_and_watched_cubit.dart';
import '../../../utilities/utilities.dart';
import '../../movie_details/movie_details_page.dart';
import '../../widgets/build_poster_image.dart';

class MovieWatchedTab extends StatefulWidget {
  const MovieWatchedTab({Key? key}) : super(key: key);

  @override
  State<MovieWatchedTab> createState() => _MovieWatchedTabState();
}

class _MovieWatchedTabState extends State<MovieWatchedTab> {
  late ScrollController _scrollController;

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

  @override
  Widget build(BuildContext context) => BlocBuilder<UserWatchlistAndWatchedCubit, UserWatchlistAndWatchedState>(
        builder: (context, state) => state.watched.isEmpty
            ? const Center(
                child: Text(
                  "Movies reviewed will show up here",
                ),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                    context.read<UserWatchlistAndWatchedCubit>().nextPageMovieWatchedCalled();
                  }
                  return false;
                },
                child: GridView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.69,
                  ),
                  itemCount: state.isThereMoreWatchedToLoad ? state.watched.length + 1 : state.watched.length,
                  itemBuilder: (context, index) => index >= state.watched.length
                      ? const BuildLoaderNextPage()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: false).push(
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsPage(
                                    tmdbId: state.watched[index].id,
                                    title: state.watched[index].title,
                                  ),
                                ),
                              );
                            },
                            child: AspectRatio(
                              aspectRatio: 0.69,
                              child: BuildPosterImage(
                                height: 135,
                                width: 90,
                                imagePath: state.watched[index].posterPath,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
      );
}
