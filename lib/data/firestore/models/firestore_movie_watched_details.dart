import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMovieWatchedDetails {
  FirestoreMovieWatchedDetails({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.popularity,
    required this.voteAverage,
    required this.releaseDate,
    required this.timestampAddedToFirestore,
    required this.review,
    required this.rating,
  });

  final int id;
  final String title;
  final String posterPath;
  final num popularity;
  final num voteAverage;
  final String releaseDate;
  final Timestamp timestampAddedToFirestore;
  final String review;
  final num rating;

// added fromSnapshot and toDocument methods to add movie info to firestore, but only certain fields, not all
  factory FirestoreMovieWatchedDetails.fromMap(Map<String, dynamic> data) => FirestoreMovieWatchedDetails(
        id: data['id'] as int? ?? 0,
        title: data['title'] as String? ?? '',
        posterPath: data['poster_path'] as String? ?? '',
        popularity: data['popularity'] as num? ?? 0,
        voteAverage: data['vote_average'] as num? ?? 0,
        releaseDate: data['release_date'] as String? ?? '',
        timestampAddedToFirestore: data['added_to_list_date'] as Timestamp? ?? Timestamp(0, 0),
        review: data['review'] as String? ?? '',
        rating: data['rating'] as num? ?? 0,
      );

  factory FirestoreMovieWatchedDetails.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      FirestoreMovieWatchedDetails.fromMap(snapshot.data() ?? {});

  Map<String, dynamic> toDocument() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'popularity': popularity,
        'vote_average': voteAverage,
        'release_date': releaseDate,
        'added_to_list_date': timestampAddedToFirestore,
        'review': review,
        'rating': rating,
      };
}
