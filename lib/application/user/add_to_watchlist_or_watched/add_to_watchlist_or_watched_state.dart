part of 'add_to_watchlist_or_watched_cubit.dart';

enum AddToWatchlistOrWatchedStatus {
  success,
  loading,
  error,
}

class AddToWatchlistOrWatchedState extends Equatable {
  const AddToWatchlistOrWatchedState({
    this.status = AddToWatchlistOrWatchedStatus.success,
    this.watchlistAllTitles = const <String>[],
    this.watchedAllTitles = const <String>[],
    this.errorMessage = '',
    this.userReview,
  });

  final AddToWatchlistOrWatchedStatus status;
  final List<String> watchlistAllTitles;
  final List<String> watchedAllTitles;
  final String errorMessage;
  final FirestoreMovieWatchedDetails? userReview;

  AddToWatchlistOrWatchedState copyWith({
    AddToWatchlistOrWatchedStatus? status,
    List<String>? watchlistAllTitles,
    List<String>? watchedAllTitles,
    String? errorMessage,
    FirestoreMovieWatchedDetails? userReview,
  }) =>
      AddToWatchlistOrWatchedState(
        status: status ?? this.status,
        watchlistAllTitles: watchlistAllTitles ?? this.watchlistAllTitles,
        watchedAllTitles: watchedAllTitles ?? this.watchedAllTitles,
        errorMessage: errorMessage ?? this.errorMessage,
        userReview: userReview ?? this.userReview,
      );

  @override
  List<Object> get props => [
        status,
        watchlistAllTitles,
        watchedAllTitles,
        errorMessage,
      ];
}
