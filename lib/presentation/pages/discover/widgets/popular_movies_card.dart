import 'package:flutter/material.dart';

import '../../../../data/movies/models/movie_search/movie_summary.dart';
import '../../movie_details/movie_details_page.dart';
import '../../widgets/build_poster_image.dart';

class PopularMoviesCard extends StatelessWidget {
  const PopularMoviesCard({Key? key, required this.movieSummary}) : super(key: key);

  final MovieSummary movieSummary;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(
                  movieSummary: movieSummary,
                ),
              ),
            );
          },
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 0.69,
                child: BuildPosterImage(
                  height: 135,
                  width: 90,
                  imagePath: movieSummary.posterPath,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text(
                    movieSummary.voteCount > 100 && movieSummary.voteAverage != 0
                        ? "⭐ ${movieSummary.voteAverage}"
                        : "⭐ N/A",
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
      );
}
