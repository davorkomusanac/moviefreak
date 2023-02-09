import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/user/user_watchlist_and_watched/user_watchlist_and_watched_cubit.dart';
import '../../../utilities/utilities.dart';
import '../../movie_details/movie_details_page.dart';
import '../../widgets/build_poster_image.dart';

class MovieWatchlistTab extends StatefulWidget {
  const MovieWatchlistTab({Key? key}) : super(key: key);

  @override
  State<MovieWatchlistTab> createState() => _MovieWatchlistTabState();
}

class _MovieWatchlistTabState extends State<MovieWatchlistTab> {
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
        builder: (context, state) => state.watchlist.isEmpty
            ? const Center(
                child: Text(
                  "Movies added to watchlist will show up here",
                ),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                    context.read<UserWatchlistAndWatchedCubit>().nextPageMovieWatchlistCalled();
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
                  itemCount: state.isThereMoreWatchlistToLoad ? state.watchlist.length + 1 : state.watchlist.length,
                  itemBuilder: (context, index) => index >= state.watchlist.length
                      ? const BuildLoaderNextPage()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: false).push(
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsPage(
                                    tmdbId: state.watchlist[index].id,
                                    title: state.watchlist[index].title,
                                  ),
                                ),
                              );
                            },
                            child: AspectRatio(
                              aspectRatio: 0.69,
                              child: BuildPosterImage(
                                height: 135,
                                width: 90,
                                imagePath: state.watchlist[index].posterPath,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
      );
}
