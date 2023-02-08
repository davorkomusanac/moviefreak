import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/user/add_to_watchlist_or_watched/add_to_watchlist_or_watched_cubit.dart';

class MovieRemoveWatchlistDialog extends StatefulWidget {
  final int tmdbId;
  final String title;

  const MovieRemoveWatchlistDialog({
    super.key,
    required this.tmdbId,
    required this.title,
  });

  @override
  State<MovieRemoveWatchlistDialog> createState() => _MovieRemoveWatchlistDialogState();
}

class _MovieRemoveWatchlistDialogState extends State<MovieRemoveWatchlistDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Confirm if you want to remove from Watchlist"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              context.read<AddToWatchlistOrWatchedCubit>().removeMovieFromWatchlistPressed(
                    tmdbId: widget.tmdbId,
                    title: widget.title,
                  );
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("Yes"),
          ),
        ],
      );
}
