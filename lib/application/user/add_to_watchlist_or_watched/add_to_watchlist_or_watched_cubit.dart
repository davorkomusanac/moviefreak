import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/firestore/repository/firestore_repository.dart';

part 'add_to_watchlist_or_watched_state.dart';

class AddToWatchlistOrWatchedCubit extends Cubit<AddToWatchlistOrWatchedState> {
  final FirestoreRepository firestoreRepository;

  AddToWatchlistOrWatchedCubit({required this.firestoreRepository}) : super(const AddToWatchlistOrWatchedState());

  Future<void> loadAllTitlesWatchlistAndWatchedPressed() async {
    try {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.loading,
        ),
      );
      var watchlistTitles = await firestoreRepository.allTitlesInWatchlist();
      var watchedTitles = await firestoreRepository.allTitlesInWatched();

      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.success,
          watchlistAllTitles: watchlistTitles,
          watchedAllTitles: watchedTitles,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addMovieToWatchlistPressed({
    required int tmdbId,
    required String title,
    required String posterPath,
  }) async {
    try {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.loading,
        ),
      );
      await firestoreRepository.addMovieToWatchlist(
        tmdbId: tmdbId,
        title: title,
        posterPath: posterPath,
      );
      var updatedWatchlistAllTitles = [...state.watchlistAllTitles];
      updatedWatchlistAllTitles.add("${title.replaceAll('/', ' ')}_$tmdbId");
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.success,
          watchlistAllTitles: updatedWatchlistAllTitles,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeMovieFromWatchlistPressed({
    required int tmdbId,
    required String title,
  }) async {
    try {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.loading,
        ),
      );
      await firestoreRepository.removeMovieFromWatchlist(
        tmdbId: tmdbId,
        title: title,
      );
      var updatedWatchlistAllTitles = [...state.watchlistAllTitles];
      updatedWatchlistAllTitles.remove("${title.replaceAll('/', ' ')}_$tmdbId");
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.success,
          watchlistAllTitles: updatedWatchlistAllTitles,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addMovieToWatchedPressed({
    required int tmdbId,
    required String title,
    required String posterPath,
    required String review,
    required num rating,
  }) async {
    try {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.loading,
        ),
      );
      await firestoreRepository.addMovieToWatched(
        tmdbId: tmdbId,
        title: title,
        posterPath: posterPath,
        review: review,
        rating: rating,
      );
      var updatedWatchedAllTitles = [...state.watchedAllTitles];
      updatedWatchedAllTitles.add("${title.replaceAll('/', ' ')}_$tmdbId");
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.success,
          watchedAllTitles: updatedWatchedAllTitles,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeMovieFromWatchedPressed({
    required int tmdbId,
    required String title,
  }) async {
    try {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.loading,
        ),
      );
      await firestoreRepository.removeMovieFromWatched(
        tmdbId: tmdbId,
        title: title,
      );
      var updatedWatchedAllTitles = [...state.watchedAllTitles];
      updatedWatchedAllTitles.remove("${title.replaceAll('/', ' ')}_$tmdbId");
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.success,
          watchedAllTitles: updatedWatchedAllTitles,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateMovieToWatchedPressed({
    required int tmdbId,
    required String title,
    required String posterPath,
    required String review,
    required num rating,
  }) async {
    try {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.loading,
        ),
      );
      await firestoreRepository.updateMovieWatched(
        tmdbId: tmdbId,
        title: title,
        posterPath: posterPath,
        review: review,
        rating: rating,
      );
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddToWatchlistOrWatchedStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
