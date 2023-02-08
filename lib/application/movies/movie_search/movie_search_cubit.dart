import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/movies/models/movie_search/movie_search_results.dart';
import '../../../data/movies/models/movie_search/movie_summary.dart';
import '../../../data/movies/repository/movie_repository.dart';

part 'movie_search_state.dart';

class MovieSearchCubit extends Cubit<MovieSearchState> {
  final MovieRepository movieRepository;

  MovieSearchCubit({required this.movieRepository}) : super(const MovieSearchState());

  Future<void> searchTitleChanged({required String title}) async {
    if (title.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: '',
          searchTitle: '',
        ),
      );
    } else {
      try {
        emit(
          state.copyWith(
            status: MovieSearchStatus.loading,
            errorMessage: '',
            searchTitle: title,
          ),
        );
        var results = await movieRepository.searchMovie(title);

        emit(
          state.copyWith(
            status: MovieSearchStatus.success,
            movieSearchResults: results,
            searchPageNum: 1,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: MovieSearchStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> nextSearchResultPageCalled() async {
    if (state.searchPageNum < state.movieSearchResults.totalPages) {
      try {
        var newMovieResults = await movieRepository.searchMovie(
          state.searchTitle,
          state.searchPageNum + 1,
        );
        var updatedMovieSummaries = [
          ...state.movieSearchResults.movieSummaries,
          ...newMovieResults.movieSummaries,
        ];
        var updatedMovieResults = MovieSearchResults(
          page: state.movieSearchResults.page,
          totalResults: state.movieSearchResults.totalResults,
          totalPages: state.movieSearchResults.totalPages,
          movieSummaries: updatedMovieSummaries,
        );

        emit(
          state.copyWith(
            searchPageNum: state.searchPageNum + 1,
            movieSearchResults: updatedMovieResults,
            status: MovieSearchStatus.success,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: MovieSearchStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
