part of 'popular_movies_cubit.dart';

enum PopularMoviesStatus {
  success,
  error,
}

class PopularMoviesState extends Equatable {
  const PopularMoviesState({
    this.status = PopularMoviesStatus.success,
    this.errorMessage = '',
    this.popularPageNum = 1,
    this.popularMovies = const MovieSearchResults(
      totalResults: 0,
      page: 1,
      totalPages: 1,
      movieSummaries: <MovieSummary>[],
    ),
  });

  final PopularMoviesStatus status;
  final String errorMessage;
  final int popularPageNum;
  final MovieSearchResults popularMovies;

  PopularMoviesState copyWith({
    PopularMoviesStatus? status,
    String? errorMessage,
    int? popularPageNum,
    MovieSearchResults? popularMovies,
  }) =>
      PopularMoviesState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        popularPageNum: popularPageNum ?? this.popularPageNum,
        popularMovies: popularMovies ?? this.popularMovies,
      );

  @override
  List<Object> get props => [
        status,
        errorMessage,
        popularPageNum,
        popularMovies,
      ];
}
