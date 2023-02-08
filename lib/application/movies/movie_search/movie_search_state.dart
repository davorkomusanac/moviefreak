part of 'movie_search_cubit.dart';

enum MovieSearchStatus {
  loading,
  success,
  error,
}

class MovieSearchState extends Equatable {
  const MovieSearchState({
    this.status = MovieSearchStatus.loading,
    this.errorMessage = '',
    this.searchTitle = '',
    this.searchPageNum = 1,
    this.movieSearchResults = const MovieSearchResults(
      totalResults: 0,
      page: 1,
      totalPages: 1,
      movieSummaries: <MovieSummary>[],
    ),
  });

  final MovieSearchStatus status;
  final String errorMessage;
  final String searchTitle;
  final int searchPageNum;
  final MovieSearchResults movieSearchResults;

  MovieSearchState copyWith({
    MovieSearchStatus? status,
    String? errorMessage,
    String? searchTitle,
    int? searchPageNum,
    MovieSearchResults? movieSearchResults,
  }) =>
      MovieSearchState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        searchTitle: searchTitle ?? this.searchTitle,
        searchPageNum: searchPageNum ?? this.searchPageNum,
        movieSearchResults: movieSearchResults ?? this.movieSearchResults,
      );

  @override
  List<Object> get props => [
        status,
        searchTitle,
        errorMessage,
        searchPageNum,
        movieSearchResults,
      ];
}
