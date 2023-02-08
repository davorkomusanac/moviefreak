import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/movies/models/movie_details/movie_details.dart';
import '../../../data/movies/models/movie_search/movie_search_results.dart';
import '../../../data/movies/repository/movie_repository.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final MovieRepository movieRepository;

  MovieDetailsCubit({required this.movieRepository}) : super(const MovieDetailsState());

  Future<void> movieDetailsOpened({required int id}) async {
    try {
      emit(
        state.copyWith(
          status: MovieDetailsStatus.loading,
        ),
      );

      var movieDetails = await movieRepository.getMovieDetails(id);
      emit(
        state.copyWith(
          status: MovieDetailsStatus.success,
          movieDetails: movieDetails,
          isTrailerAvailable: _isTrailerAvailable(movieDetails),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MovieDetailsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  bool _isTrailerAvailable(MovieDetails movieDetails) {
    bool returnValue = false;
    if (movieDetails.videos.results.isNotEmpty) {
      for (var video in movieDetails.videos.results) {
        if (video.type == "Trailer") returnValue = true;
      }
    }
    return returnValue;
  }
}
