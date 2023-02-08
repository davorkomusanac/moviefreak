import 'package:flutter/material.dart';

import '../../../data/movies/models/movie_search/movie_summary.dart';

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({
    Key? key,
    required this.movieSummary,
  }) : super(key: key);

  final MovieSummary movieSummary;

  @override
  Widget build(BuildContext context) => const Placeholder();
}
