import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/movies/models/movie_search/movie_search_results.dart';
import '../../../data/movies/models/movie_search/movie_summary.dart';
import '../../../data/movies/repository/movie_repository.dart';

part 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final MovieRepository movieRepository;

  PopularMoviesCubit({required this.movieRepository}) : super(const PopularMoviesState());

  Future<void> popularMoviesCalled() async {
    try {
      var results = await movieRepository.getPopularMovies();
      emit(
        state.copyWith(
          status: PopularMoviesStatus.success,
          popularMovies: results,
          popularPageNum: 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PopularMoviesStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> popularMoviesNextPageCalled() async {
    if (state.popularPageNum < state.popularMovies.totalPages) {
      try {
        var nextPagePopularMovies = await movieRepository.getPopularMovies(
          state.popularPageNum + 1,
        );
        var updatedMovieSummaries = [
          ...state.popularMovies.movieSummaries,
          ...nextPagePopularMovies.movieSummaries,
        ];
        var updatedMovieResults = MovieSearchResults(
          page: state.popularMovies.page,
          totalResults: state.popularMovies.totalResults,
          totalPages: state.popularMovies.totalPages,
          movieSummaries: updatedMovieSummaries,
        );

        emit(
          state.copyWith(
            popularPageNum: state.popularPageNum + 1,
            popularMovies: updatedMovieResults,
            status: PopularMoviesStatus.success,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: PopularMoviesStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
