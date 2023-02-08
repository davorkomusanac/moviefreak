import 'package:flutter/material.dart';

import '../../../../data/movies/models/movie_search/movie_summary.dart';
import '../../../utilities/utilities.dart';
import '../../movie_details/movie_details_page.dart';
import '../../widgets/build_poster_image.dart';

class MovieSearchCard extends StatelessWidget {
  const MovieSearchCard({Key? key, required this.movieSummary}) : super(key: key);

  final MovieSummary movieSummary;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12.0),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: BuildPosterImage(
                  height: 190,
                  width: 132,
                  imagePath: movieSummary.posterPath,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        movieSummary.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                      child: Text(
                        movieSummary.overview.isEmpty ? "Plot unknown" : movieSummary.overview,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        convertReleaseDate(movieSummary.releaseDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
