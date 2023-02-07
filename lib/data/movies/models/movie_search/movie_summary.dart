class MovieSummary {
  final String posterPath;
  final String overview;
  final String releaseDate;
  final List<num> genreIds;
  final int id;
  final String title;
  final String backdropPath;
  final num popularity;
  final num voteAverage;
  final int voteCount;

  const MovieSummary({
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.genreIds,
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieSummary.fromJson(dynamic result) => MovieSummary(
        posterPath: result['poster_path'] as String? ?? '',
        overview: result['overview'] as String? ?? '',
        releaseDate: result['release_date'] as String? ?? 'Release date unknown',
        genreIds: result['genre_ids']?.cast<num>() ?? <num>[],
        id: result['id'] as int? ?? 0,
        title: result['title'] as String? ?? '',
        backdropPath: result['backdrop_path'] as String? ?? '',
        popularity: result['popularity'] as num? ?? 0,
        voteAverage: result['vote_average'] as num? ?? 0,
        voteCount: result['vote_count'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "overview": overview,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "popularity": popularity,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  @override
  String toString() => 'MovieSummary{id: $id, title: $title}';
}
