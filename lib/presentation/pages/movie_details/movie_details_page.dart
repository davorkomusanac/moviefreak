import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../application/movies/movie_details/movie_details_cubit.dart';
import '../../../application/user/add_to_watchlist_or_watched/add_to_watchlist_or_watched_cubit.dart';
import '../../../data/movies/models/movie_details/movie_details.dart';
import '../../../data/movies/models/movie_search/movie_summary.dart';
import '../../../styles.dart';
import '../../utilities/utilities.dart';
import '../widgets/build_poster_image.dart';
import 'widgets/movie_remove_review_dialog.dart';
import 'widgets/movie_remove_watchlist_dialog.dart';
import 'widgets/movie_review_dialog.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({
    Key? key,
    required this.movieSummary,
  }) : super(key: key);

  final MovieSummary movieSummary;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  bool isOverviewExpanded = false;
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

  @override
  void didChangeDependencies() {
    context.read<MovieDetailsCubit>().movieDetailsOpened(
          id: widget.movieSummary.id,
        );
    context.read<AddToWatchlistOrWatchedCubit>().loadUserReviewCalled(
          title: widget.movieSummary.title,
          tmdbId: widget.movieSummary.id,
        );
    super.didChangeDependencies();
  }

  //Method to call, when Navigator.pop is called, to update the movieDetails page
  void sendEvent() {
    context.read<MovieDetailsCubit>().movieDetailsOpened(
          id: widget.movieSummary.id,
        );
    context.read<AddToWatchlistOrWatchedCubit>().loadUserReviewCalled(
          title: widget.movieSummary.title,
          tmdbId: widget.movieSummary.id,
        );
  }

  void _launchTrailer(BuildContext context, MovieVideos videos) async {
    String trailerKey = '';
    for (var video in videos.results) {
      if (video.type == "Trailer") {
        trailerKey = video.key;
        break;
      }
    }
    String videoUrl = "https://www.youtube.com/watch?v=$trailerKey";
    try {
      if (await canLaunchUrl(Uri.parse(videoUrl))) {
        await launchUrl(Uri.parse(videoUrl));
      } else {
        throw 'Could not launch trailer link';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
            builder: (context, state) {
              switch (state.status) {
                case MovieDetailsStatus.loading:
                  return const BuildSearchProgressIndicator();
                case MovieDetailsStatus.error:
                  return BuildSearchErrorMessage(state.errorMessage);
                case MovieDetailsStatus.success:
                  return CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            ///
                            ///Backdrop cover image
                            ///
                            Material(
                              elevation: 10,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.35,
                                  child: CachedNetworkImage(
                                    imageUrl: "https://image.tmdb.org/t/p/w780/${state.movieDetails.backdropPath}",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.green,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.black,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text('😢'),
                                          SizedBox(height: 5),
                                          Text(
                                            'No image available',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            ///
                            ///Title and trailer
                            ///
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        top: 20.0,
                                        right: 16.0,
                                      ),
                                      child: Text(
                                        state.movieDetails.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    right: 20.0,
                                  ),
                                  child: TextButton(
                                    //Check for trailer availability
                                    onPressed: state.isTrailerAvailable
                                        ? () {
                                            _launchTrailer(context, state.movieDetails.videos);
                                          }
                                        : null,
                                    child: Text(
                                      state.isTrailerAvailable ? "TRAILER" : "NO TRAILER",
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            ///
                            /// Runtime and rating
                            ///
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      top: 8.0,
                                      right: 8.0,
                                      bottom: 8.0,
                                    ),
                                    child: Text(
                                      convertReleaseDate(state.movieDetails.releaseDate),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      convertRuntime(state.movieDetails.runtime),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      right: 8.0,
                                    ),
                                    child: Text(
                                      state.movieDetails.voteAverage != 0 && state.movieDetails.voteCount > 100
                                          ? "⭐ ${state.movieDetails.voteAverage.toStringAsFixed(1)} / 10"
                                          : "⭐ No rating",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            ///
                            /// Watchlist and Watched buttons
                            ///
                            BlocConsumer<AddToWatchlistOrWatchedCubit, AddToWatchlistOrWatchedState>(
                              listener: (context, watchlistState) {
                                if (watchlistState.status == AddToWatchlistOrWatchedStatus.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(watchlistState.errorMessage),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              builder: (context, watchlistState) {
                                //Check if movie is watchList so that buttons can be updated correctly
                                bool isInWatchlist = false;
                                bool isInWatched = false;
                                String compare = "${state.movieDetails.title}_${state.movieDetails.id}";
                                for (var movie in watchlistState.watchlistAllTitles) {
                                  if (movie == compare) {
                                    isInWatchlist = true;
                                  }
                                }
                                for (var movie in watchlistState.watchedAllTitles) {
                                  if (movie == compare) {
                                    isInWatched = true;
                                  }
                                }
                                return watchlistState.status == AddToWatchlistOrWatchedStatus.loading
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                              child: ElevatedButton(
                                                style: isInWatchlist ? kWatchedButton : kNotWatchedButton,
                                                onPressed: () {
                                                  if (isInWatchlist) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => MovieRemoveWatchlistDialog(
                                                        tmdbId: state.movieDetails.id,
                                                        title: state.movieDetails.title,
                                                      ),
                                                    );
                                                  } else {
                                                    context
                                                        .read<AddToWatchlistOrWatchedCubit>()
                                                        .addMovieToWatchlistPressed(
                                                          tmdbId: state.movieDetails.id,
                                                          title: state.movieDetails.title,
                                                          posterPath: state.movieDetails.posterPath,
                                                        );
                                                  }
                                                },
                                                child: Text(isInWatchlist ? "✅ In Watchlist" : "Add to Watchlist"),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                              child: ElevatedButton(
                                                style: isInWatched ? kWatchedButton : kNotWatchedButton,
                                                onPressed: () {
                                                  if (isInWatched) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => MovieRemoveReviewDialog(
                                                        tmdbId: state.movieDetails.id,
                                                        title: state.movieDetails.title,
                                                      ),
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => MovieReviewDialog(
                                                        tmdbId: state.movieDetails.id,
                                                        title: state.movieDetails.title,
                                                        posterPath: state.movieDetails.posterPath,
                                                        isInWatchlist: isInWatchlist,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text(isInWatched ? "✅ Watched" : "Rate it"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),

                            ///
                            /// User Review
                            ///
                            BlocBuilder<AddToWatchlistOrWatchedCubit, AddToWatchlistOrWatchedState>(
                              builder: (context, watchlistState) => watchlistState.userReview != null &&
                                      watchlistState.userReview!.review.isNotEmpty &&
                                      watchlistState.status == AddToWatchlistOrWatchedStatus.success
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 16.0,
                                                top: 8.0,
                                                bottom: 8.0,
                                                right: 8.0,
                                              ),
                                              child: Text(
                                                "Your Review",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => MovieReviewDialog(
                                                      tmdbId: state.movieDetails.id,
                                                      title: state.movieDetails.title,
                                                      posterPath: state.movieDetails.posterPath,
                                                      isInWatchlist: false,
                                                      rating: watchlistState.userReview?.rating.toDouble() ?? 6.0,
                                                      review: watchlistState.userReview?.review ?? '',
                                                    ),
                                                  );
                                                },
                                                child: const Text('Edit'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16.0,
                                            bottom: 8.0,
                                            right: 8.0,
                                          ),
                                          child: Text(
                                            "You rated it ⭐ ${watchlistState.userReview?.rating.toInt().toString()} / 10",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16.0,
                                            bottom: 8.0,
                                            right: 8.0,
                                          ),
                                          child: Text(
                                            watchlistState.userReview?.review ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    )
                                  : const Offstage(),
                            ),

                            ///
                            /// Tagline
                            ///
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Text(
                                    state.movieDetails.tagline.isNotEmpty ? state.movieDetails.tagline : "Overview",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isOverviewExpanded = !isOverviewExpanded;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          state.movieDetails.overview,
                                          style: const TextStyle(fontSize: 16),
                                          maxLines: isOverviewExpanded ? 30 : 5,
                                          overflow: TextOverflow.fade,
                                        ),
                                        if (!isOverviewExpanded && state.movieDetails.overview.length > 250)
                                          const Icon(Icons.more_horiz),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            ///
                            ///Cast and Crew
                            ///
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Text(
                                    "Cast",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: state.movieDetails.credits.cast.isEmpty ? 80 : 230,
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: state.movieDetails.credits.cast.isEmpty
                                  ? const Center(
                                      child: OutlinedButton(
                                        onPressed: null,
                                        child: Text("Currently unavailable"),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.movieDetails.credits.cast.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        child: SizedBox(
                                          width: 90,
                                          child: Column(
                                            children: [
                                              BuildPosterImage(
                                                height: 135,
                                                width: 90,
                                                imagePath: state.movieDetails.credits.cast[index].profilePath,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                                child: Text(
                                                  state.movieDetails.credits.cast[index].name,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  state.movieDetails.credits.cast[index].character,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                            ),

                            ///
                            ///Similar movies
                            ///
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Text(
                                    "Similar movies",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: state.movieDetails.movieSearchResults.movieSummaries.isEmpty ? 70 : 220,
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 8.0,
                                right: 8.0,
                              ),
                              child: state.movieDetails.movieSearchResults.movieSummaries.isEmpty
                                  ? const Center(
                                      child: OutlinedButton(
                                        onPressed: null,
                                        child: Text("Currently unavailable"),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.movieDetails.movieSearchResults.movieSummaries.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          bottom: 8.0,
                                          right: 8.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            //Had to add .then and call setState, so that the first page is refreshed if it is popped back, from the second page where the Navigator
                                            //is going to push right now (otherwise each page will have the identical MovieDetails)
                                            Navigator.of(context, rootNavigator: false)
                                                .push(
                                                  MaterialPageRoute(
                                                    builder: (context) => MovieDetailsPage(
                                                      movieSummary:
                                                          state.movieDetails.movieSearchResults.movieSummaries[index],
                                                    ),
                                                  ),
                                                )
                                                .then(
                                                  (value) => setState(
                                                    () {
                                                      sendEvent();
                                                    },
                                                  ),
                                                );
                                          },
                                          child: SizedBox(
                                            width: 90,
                                            child: Column(
                                              children: [
                                                BuildPosterImage(
                                                  height: 135,
                                                  width: 90,
                                                  imagePath: state
                                                      .movieDetails.movieSearchResults.movieSummaries[index].posterPath,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                      top: 8.0,
                                                      bottom: 4.0,
                                                    ),
                                                    child: Text(
                                                      state.movieDetails.movieSearchResults.movieSummaries[index]
                                                                      .voteAverage !=
                                                                  0 &&
                                                              state.movieDetails.movieSearchResults
                                                                      .movieSummaries[index].voteCount >
                                                                  100
                                                          ? "⭐${state.movieDetails.movieSearchResults.movieSummaries[index].voteAverage.toStringAsFixed(1)} ${state.movieDetails.movieSearchResults.movieSummaries[index].title}"
                                                          : "⭐ N/A ${state.movieDetails.movieSearchResults.movieSummaries[index].title}",
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
              }
            },
          ),
        ),
      );
}
