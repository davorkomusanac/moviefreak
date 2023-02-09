import 'package:flutter/material.dart';

import '../../../../data/firestore/models/firestore_movie_watched_details.dart';

class UserReview extends StatelessWidget {
  const UserReview({
    Key? key,
    required this.userReview,
  }) : super(key: key);

  final FirestoreMovieWatchedDetails userReview;

  @override
  Widget build(BuildContext context) => const Placeholder();
}
