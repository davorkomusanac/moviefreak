import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');
  final CollectionReference _movies = FirebaseFirestore.instance.collection('movies');

  Future<void> addMovieToWatchlist({
    required int tmdbId,
    required String title,
    required String posterPath,
  }) async {}
}
