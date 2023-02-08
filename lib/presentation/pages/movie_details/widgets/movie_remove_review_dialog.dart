import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/user/add_to_watchlist_or_watched/add_to_watchlist_or_watched_cubit.dart';

class MovieRemoveReviewDialog extends StatefulWidget {
  final int tmdbId;
  final String title;

  const MovieRemoveReviewDialog({
    super.key,
    required this.tmdbId,
    required this.title,
  });

  @override
  State<MovieRemoveReviewDialog> createState() => _MovieRemoveReviewDialogState();
}

class _MovieRemoveReviewDialogState extends State<MovieRemoveReviewDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Confirm if you want to remove from Watched"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Note: this action cannot be undone, your rating and review will be lost."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              context.read<AddToWatchlistOrWatchedCubit>().removeMovieFromWatchedPressed(
                    title: widget.title,
                    tmdbId: widget.tmdbId,
                  );
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("Yes"),
          ),
        ],
      );
}
