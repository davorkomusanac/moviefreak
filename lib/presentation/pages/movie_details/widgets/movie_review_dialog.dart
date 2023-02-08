import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/user/add_to_watchlist_or_watched/add_to_watchlist_or_watched_cubit.dart';

class MovieReviewDialog extends StatefulWidget {
  final int tmdbId;
  final String title;
  final String posterPath;
  final bool isInWatchlist;

  const MovieReviewDialog({
    super.key,
    required this.tmdbId,
    required this.title,
    required this.posterPath,
    required this.isInWatchlist,
  });

  @override
  State<MovieReviewDialog> createState() => _MovieReviewDialogState();
}

class _MovieReviewDialogState extends State<MovieReviewDialog> {
  double rating = 6.0;
  late final TextEditingController _movieReviewController;

  @override
  void initState() {
    super.initState();
    _movieReviewController = TextEditingController();
  }

  @override
  void dispose() {
    _movieReviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
          actionsPadding: const EdgeInsets.only(
            right: 16,
            bottom: 12,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24.0,
            20.0,
            24.0,
            0.0,
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          //title: Text("Rate the movie and write a review"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "⭐ ${rating.toInt().toString()}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Slider(
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    value: rating,
                    activeColor: Colors.blue,
                    onChanged: (double value) {
                      setState(() {
                        rating = value;
                      });
                    }),
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    enableSuggestions: true,
                    autocorrect: true,
                    controller: _movieReviewController,
                    maxLines: 80,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      hintText: 'Type your review here...',
                      counter: Offstage(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AddToWatchlistOrWatchedCubit>().addMovieToWatchedPressed(
                      tmdbId: widget.tmdbId,
                      title: widget.title,
                      posterPath: widget.posterPath,
                      review: _movieReviewController.text,
                      rating: rating,
                    );
                if (widget.isInWatchlist) {
                  context.read<AddToWatchlistOrWatchedCubit>().removeMovieFromWatchlistPressed(
                        tmdbId: widget.tmdbId,
                        title: widget.title,
                      );
                }
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      );
}
