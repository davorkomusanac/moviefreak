import '../movie_search/movie_search_results.dart';

class MovieDetails {
  const MovieDetails({
    required this.adult,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.credits,
    required this.movieSearchResults,
    required this.videos,
  });

  final bool adult;
  final String backdropPath;
  final int budget;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final String imdbId;
  final String originalTitle;
  final String overview;
  final num popularity;
  final String posterPath;
  final String releaseDate;
  final int revenue;
  final int runtime;
  final String status;
  final String tagline;
  final String title;
  final bool video;
  final num voteAverage;
  final int voteCount;
  //Appended responses
  final Credits credits;
  final MovieSearchResults movieSearchResults;
  //Appended video for trailers
  final MovieVideos videos;

  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
        adult: json["adult"] as bool? ?? false,
        backdropPath: json["backdrop_path"] as String? ?? '',
        budget: json["budget"] as int? ?? 0,
        genres: json["genres"] != null
            ? List<Genre>.from(
                json["genres"].map((x) => Genre.fromJson(x)),
              )
            : <Genre>[],
        homepage: json["homepage"] as String? ?? '',
        id: json["id"] as int? ?? 0,
        imdbId: json["imdb_id"] as String? ?? '',
        originalTitle: json["original_title"] as String? ?? '',
        overview: json["overview"] as String? ?? 'Plot unknown',
        popularity: json["popularity"] as num? ?? 0.0,
        posterPath: json["poster_path"] as String? ?? '',
        releaseDate: json["release_date"] as String? ?? 'Release date unknown',
        revenue: json["revenue"] as int? ?? 0,
        runtime: json["runtime"] as int? ?? 0,
        status: json["status"] as String? ?? '',
        tagline: json["tagline"] as String? ?? '',
        title: json["title"] as String? ?? '',
        video: json["video"] as bool? ?? false,
        voteAverage: json["vote_average"] as num? ?? 0.0,
        voteCount: json["vote_count"] as int? ?? 0,
        credits: json["credits"] != null
            ? Credits.fromJson(
                json["credits"],
              )
            : Credits(cast: <Cast>[], crew: <Cast>[]),
        movieSearchResults: json["recommendations"] != null
            ? MovieSearchResults.fromJson(json["recommendations"], 1)
            : const MovieSearchResults(
                totalResults: 0,
                page: 1,
                movieSummaries: [],
                totalPages: 0,
              ),
        videos: json["videos"] != null
            ? MovieVideos.fromJson(
                json["videos"],
              )
            : MovieVideos(
                results: <VideosResult>[],
              ),
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "budget": budget,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "revenue": revenue,
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "credits": credits.toJson(),
        "movieSearchResults": movieSearchResults.toJson(),
        "videos": videos.toJson(),
      };
}

class Credits {
  const Credits({
    required this.cast,
    required this.crew,
  });

  final List<Cast> cast;
  final List<Cast> crew;

  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
        cast: json["cast"] is List
            ? List<Cast>.from(
                json["cast"].map(
                  (x) => Cast.fromJson(x),
                ),
              )
            : <Cast>[],
        crew: json["crew"] is List
            ? List<Cast>.from(
                json["crew"].map(
                  (x) => Cast.fromJson(x),
                ),
              )
            : <Cast>[],
      );

  Map<String, dynamic> toJson() => {
        "cast": List<dynamic>.from(
          cast.map(
            (x) => x.toJson(),
          ),
        ),
        "crew": List<dynamic>.from(
          crew.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class Cast {
  const Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
    required this.department,
    required this.job,
  });

  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final num popularity;
  final String profilePath;
  final int castId;
  final String character;
  final String creditId;
  final int order;
  final String department;
  final String job;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"] as bool? ?? false,
        gender: json["gender"] as int? ?? 0,
        id: json["id"] as int? ?? 0,
        knownForDepartment: json["known_for_department"] as String? ?? '',
        name: json["name"] as String? ?? '',
        originalName: json["original_name"] as String? ?? '',
        popularity: json["popularity"] as num? ?? 0.0,
        profilePath: json["profile_path"] as String? ?? '',
        castId: json["cast_id"] as int? ?? 0,
        character: json["character"] as String? ?? '',
        creditId: json["credit_id"] as String? ?? '',
        order: json["order"] as int? ?? 0,
        department: json["department"] as String? ?? '',
        job: json["job"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
        "cast_id": castId,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "department": department,
        "job": job
      };
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"] as int? ?? 0,
        name: json["name"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class MovieVideos {
  const MovieVideos({
    required this.results,
  });

  final List<VideosResult> results;

  factory MovieVideos.fromJson(Map<String, dynamic> json) => MovieVideos(
        results: json["results"] is List
            ? List<VideosResult>.from(
                json["results"].map(
                  (x) => VideosResult.fromJson(x),
                ),
              )
            : <VideosResult>[],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class VideosResult {
  VideosResult({
    required this.id,
    required this.iso6391,
    required this.iso31661,
    required this.key,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
  });

  final String id;
  final String iso6391;
  final String iso31661;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;

  factory VideosResult.fromJson(Map<String, dynamic> json) => VideosResult(
        id: json["id"] as String? ?? '',
        iso6391: json["iso_639_1"] as String? ?? '',
        iso31661: json["iso_3166_1"] as String? ?? '',
        key: json["key"] as String? ?? '',
        name: json["name"] as String? ?? '',
        site: json["site"] as String? ?? '',
        size: json["size"] as int? ?? 0,
        type: json["type"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "iso_639_1": iso6391,
        "iso_3166_1": iso31661,
        "key": key,
        "name": name,
        "site": site,
        "size": size,
        "type": type,
      };
}
