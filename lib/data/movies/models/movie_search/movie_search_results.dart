import 'movie_summary.dart';

class MovieSearchResults {
  final int page;
  final int totalResults;
  final int totalPages;
  final List<MovieSummary> movieSummaries;

  const MovieSearchResults({
    required this.page,
    required this.totalResults,
    required this.totalPages,
    required this.movieSummaries,
  });

  factory MovieSearchResults.fromJson(Map<String, dynamic> json, int page) {
    if ((json['total_results'] ??= 0) == 0) {
      return MovieSearchResults(
        totalResults: 0,
        page: page,
        movieSummaries: [],
        totalPages: 0,
      );
    }

    final List<MovieSummary> movies = [];
    for (final result in json['results']) {
      movies.add(MovieSummary.fromJson(result));
    }
    return MovieSearchResults(
      page: page,
      totalResults: json['total_results'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
      movieSummaries: movies,
    );
  }
  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(movieSummaries.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
