part of 'user_watchlist_and_watched_cubit.dart';

class UserWatchlistAndWatchedState extends Equatable {
  const UserWatchlistAndWatchedState({
    this.watchlist = const <FirestoreMovieWatchlistDetails>[],
    this.watched = const <FirestoreMovieWatchedDetails>[],
    this.isThereMoreWatchlistToLoad = false,
    this.isThereMoreWatchedToLoad = false,
    this.errorMessage = '',
    this.watchlistLength = 0,
    this.watchedLength = 0,
  });

  final List<FirestoreMovieWatchlistDetails> watchlist;
  final List<FirestoreMovieWatchedDetails> watched;
  final bool isThereMoreWatchlistToLoad;
  final bool isThereMoreWatchedToLoad;
  final String errorMessage;
  final num watchlistLength;
  final num watchedLength;

  UserWatchlistAndWatchedState copyWith({
    List<FirestoreMovieWatchlistDetails>? watchlist,
    List<FirestoreMovieWatchedDetails>? watched,
    bool? isThereMoreWatchlistToLoad,
    bool? isThereMoreWatchedToLoad,
    String? errorMessage,
    num? watchlistLength,
    num? watchedLength,
  }) =>
      UserWatchlistAndWatchedState(
        watchlist: watchlist ?? this.watchlist,
        watched: watched ?? this.watched,
        isThereMoreWatchlistToLoad: isThereMoreWatchlistToLoad ?? this.isThereMoreWatchlistToLoad,
        isThereMoreWatchedToLoad: isThereMoreWatchedToLoad ?? this.isThereMoreWatchedToLoad,
        errorMessage: errorMessage ?? this.errorMessage,
        watchlistLength: watchlistLength ?? this.watchlistLength,
        watchedLength: watchedLength ?? this.watchedLength,
      );

  @override
  List<Object> get props => [
        watchlist,
        watched,
        isThereMoreWatchlistToLoad,
        isThereMoreWatchedToLoad,
        errorMessage,
        watchlistLength,
        watchedLength,
      ];
}
