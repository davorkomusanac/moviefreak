part of 'movie_details_cubit.dart';

enum MovieDetailsStatus {
  loading,
  success,
  error,
}

class MovieDetailsState extends Equatable {
  const MovieDetailsState({
    this.isTrailerAvailable = false,
    this.errorMessage = '',
    this.status = MovieDetailsStatus.loading,
    //Empty initial constant fields
    this.movieDetails = const MovieDetails(
      adult: false,
      backdropPath: '',
      budget: 0,
      genres: [],
      homepage: '',
      id: 0,
      imdbId: '',
      originalTitle: '',
      overview: '',
      popularity: 0,
      posterPath: '',
      releaseDate: '',
      revenue: 0,
      runtime: 0,
      status: '',
      tagline: '',
      title: '',
      video: false,
      voteAverage: 0,
      voteCount: 0,
      credits: Credits(cast: <Cast>[], crew: <Cast>[]),
      movieSearchResults: MovieSearchResults(
        page: 1,
        totalResults: 0,
        totalPages: 1,
        movieSummaries: [],
      ),
      videos: MovieVideos(
        results: [],
      ),
    ),
  });

  final MovieDetails movieDetails;
  final bool isTrailerAvailable;
  final String errorMessage;
  final MovieDetailsStatus status;

  MovieDetailsState copyWith({
    MovieDetails? movieDetails,
    bool? isTrailerAvailable,
    String? errorMessage,
    MovieDetailsStatus? status,
  }) =>
      MovieDetailsState(
        movieDetails: movieDetails ?? this.movieDetails,
        isTrailerAvailable: isTrailerAvailable ?? this.isTrailerAvailable,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
      );

  @override
  List<Object> get props => [
        movieDetails,
        isTrailerAvailable,
        errorMessage,
        status,
      ];
}
