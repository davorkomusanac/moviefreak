import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/firestore/models/firestore_movie_watched_details.dart';
import '../../../data/firestore/models/firestore_movie_watchlist_details.dart';
import '../../../data/firestore/repository/firestore_repository.dart';

part 'user_watchlist_and_watched_state.dart';

class UserWatchlistAndWatchedCubit extends Cubit<UserWatchlistAndWatchedState> {
  final FirestoreRepository firestoreRepository;
  StreamSubscription? _watchlistStream;
  StreamSubscription? _watchedStream;

  @override
  Future<void> close() {
    _watchlistStream?.cancel();
    _watchedStream?.cancel();
    return super.close();
  }

  UserWatchlistAndWatchedCubit({
    required this.firestoreRepository,
  }) : super(const UserWatchlistAndWatchedState());

  void initializeStreams() {
    _watchlistStream?.cancel();
    _watchlistStream = firestoreRepository.getMovieWatchlist().listen(
      (watchlist) => loadedWatchlist(watchlist),
      onError: (e) {
        emit(
          state.copyWith(
            errorMessage: e.toString(),
          ),
        );
      },
    );
    _watchedStream?.cancel();
    _watchedStream = firestoreRepository.getMovieWatched().listen(
      (watched) => loadedWatched(watched),
      onError: (e) {
        emit(
          state.copyWith(
            errorMessage: e.toString(),
          ),
        );
      },
    );
  }

  void loadedWatchlist(List<FirestoreMovieWatchlistDetails> watchlist) {
    getWatchStatsCalled();
    emit(
      state.copyWith(
        errorMessage: '',
        watchlist: watchlist,
        isThereMoreWatchlistToLoad: watchlist.length > 18,
      ),
    );
  }

  void loadedWatched(List<FirestoreMovieWatchedDetails> watched) {
    getWatchStatsCalled();
    emit(
      state.copyWith(
        errorMessage: '',
        watched: watched,
        isThereMoreWatchedToLoad: watched.length > 18,
      ),
    );
  }

  Future<void> nextPageMovieWatchlistCalled() async {
    try {
      bool isThereMore = false;
      if (state.isThereMoreWatchlistToLoad) {
        var newPageWatchlist = await firestoreRepository.getMovieWatchlistNextPage(state.watchlist.last);
        isThereMore = newPageWatchlist.length > 18;
        var updatedWatchlist = [...state.watchlist, ...newPageWatchlist];
        emit(
          state.copyWith(
            errorMessage: '',
            watchlist: updatedWatchlist,
            isThereMoreWatchlistToLoad: isThereMore,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> nextPageMovieWatchedCalled() async {
    try {
      bool isThereMore = false;
      if (state.isThereMoreWatchedToLoad) {
        var newPageWatched = await firestoreRepository.getMovieWatchedNextPage(state.watched.last);
        isThereMore = newPageWatched.length > 18;
        var updatedWatched = [...state.watched, ...newPageWatched];
        emit(
          state.copyWith(
            errorMessage: '',
            watched: updatedWatched,
            isThereMoreWatchedToLoad: isThereMore,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getWatchStatsCalled() async {
    try {
      List<num> stats = await firestoreRepository.getWatchStats();

      emit(
        state.copyWith(
          errorMessage: '',
          watchlistLength: stats.first,
          watchedLength: stats[1],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
