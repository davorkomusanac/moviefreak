import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/firestore_movie_watched_details.dart';
import '../models/firestore_movie_watchlist_details.dart';

class FirestoreRepository {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');
  final CollectionReference _movies = FirebaseFirestore.instance.collection('movies');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addMovieToWatchlist({
    required int tmdbId,
    required String title,
    required String posterPath,
  }) async {
    try {
      FirestoreMovieWatchlistDetails firestoreWatchlist = FirestoreMovieWatchlistDetails(
        id: tmdbId,
        title: title,
        posterPath: posterPath,
        timestampAddedToFirestore: Timestamp.fromDate(DateTime.now()),
      );
      WriteBatch batch = FirebaseFirestore.instance.batch();

      //Need RegExp to stop movie titles with special characters in title
      batch.set(
        _movies
            .doc(_auth.currentUser?.uid)
            .collection('watchlist')
            .doc("${firestoreWatchlist.title.replaceAll('/', ' ')}_${firestoreWatchlist.id}"),
        firestoreWatchlist.toDocument(),
      );
      //Need to also have an additional array inside user document consisting of movie id's
      //so that in MovieDetails page the movie can be updated correctly based on info
      batch.set(
        _users.doc(_auth.currentUser?.uid),
        {
          "movie_watchlist": FieldValue.arrayUnion([
            "${firestoreWatchlist.title.replaceAll('/', ' ')}_${firestoreWatchlist.id}",
          ]),
          "watchlist_length": FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
      await batch.commit();
    } catch (e) {
      log("Adding to watchlist ERROR: $e");
      throw e.toString();
    }
  }

  Future<void> addMovieToWatched({
    required int tmdbId,
    required String title,
    required String posterPath,
    required String review,
    required num rating,
  }) async {
    try {
      FirestoreMovieWatchedDetails firestoreWatched = FirestoreMovieWatchedDetails(
        id: tmdbId,
        title: title,
        posterPath: posterPath,
        timestampAddedToFirestore: Timestamp.fromDate(DateTime.now()),
        review: review,
        rating: rating,
      );
      WriteBatch batch = FirebaseFirestore.instance.batch();

      //Need RegExp to stop movie titles with special characters in title
      batch.set(
        _movies
            .doc(_auth.currentUser?.uid)
            .collection('watched')
            .doc("${firestoreWatched.title.replaceAll('/', ' ')}_${firestoreWatched.id}"),
        firestoreWatched.toDocument(),
      );

      batch.set(
        _users.doc(_auth.currentUser?.uid),
        {
          "movie_watched": FieldValue.arrayUnion([
            "${firestoreWatched.title.replaceAll('/', ' ')}_${firestoreWatched.id}",
          ]),
          "watched_length": FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
      await batch.commit();
    } catch (e) {
      log("Adding to watched ERROR: $e");
      throw e.toString();
    }
  }

  Future<void> removeMovieFromWatchlist({
    required int tmdbId,
    required String title,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.delete(
        _movies.doc(_auth.currentUser?.uid).collection('watchlist').doc(
              "${title.replaceAll('/', ' ')}_$tmdbId",
            ),
      );
      batch.set(
        _users.doc(_auth.currentUser?.uid),
        {
          "movie_watchlist": FieldValue.arrayRemove([
            "${title.replaceAll('/', ' ')}_$tmdbId",
          ]),
          "watchlist_length": FieldValue.increment(-1),
        },
        SetOptions(merge: true),
      );
      await batch.commit();
    } catch (e) {
      log("Removing from watchlist ERROR: $e");
      throw e.toString();
    }
  }

  Future<void> removeMovieFromWatched({
    required int tmdbId,
    required String title,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.delete(
        _movies.doc(_auth.currentUser?.uid).collection('watched').doc(
              "${title.replaceAll('/', ' ')}_$tmdbId",
            ),
      );
      batch.set(
        _users.doc(_auth.currentUser?.uid),
        {
          "movie_watched": FieldValue.arrayRemove([
            "${title.replaceAll('/', ' ')}_$tmdbId",
          ]),
          "watched_length": FieldValue.increment(-1),
        },
        SetOptions(merge: true),
      );
      await batch.commit();
    } catch (e) {
      log("Removing from watched ERROR: $e");
      throw e.toString();
    }
  }

  Future<void> updateMovieWatched({
    required int tmdbId,
    required String title,
    required String posterPath,
    required String review,
    required num rating,
  }) async {
    try {
      FirestoreMovieWatchedDetails firestoreWatched = FirestoreMovieWatchedDetails(
        id: tmdbId,
        title: title,
        posterPath: posterPath,
        timestampAddedToFirestore: Timestamp.fromDate(DateTime.now()),
        review: review,
        rating: rating,
      );
      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.set(
        _movies
            .doc(_auth.currentUser?.uid)
            .collection('watched')
            .doc("${firestoreWatched.title.replaceAll('/', ' ')}_${firestoreWatched.id}"),
        firestoreWatched.toDocument(),
      );
      await batch.commit();
    } catch (e) {
      log("Updating watched ERROR: $e");
      throw e.toString();
    }
  }

  Stream<List<FirestoreMovieWatchlistDetails>> getMovieWatchlist() => _movies
      .doc(_auth.currentUser?.uid)
      .collection('watchlist')
      .orderBy('added_to_list_date', descending: true)
      .limit(18)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => FirestoreMovieWatchlistDetails.fromSnapshot(doc),
            )
            .toList()
            .cast<FirestoreMovieWatchlistDetails>(),
      );

  Stream<List<FirestoreMovieWatchedDetails>> getMovieWatched() => _movies
      .doc(_auth.currentUser?.uid)
      .collection('watched')
      .orderBy('added_to_list_date', descending: true)
      .limit(18)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => FirestoreMovieWatchedDetails.fromSnapshot(doc),
            )
            .toList()
            .cast<FirestoreMovieWatchedDetails>(),
      );

  //Pagination for lists
  Future<List<FirestoreMovieWatchlistDetails>> getMovieWatchlistNextPage(
      FirestoreMovieWatchlistDetails lastItemInList) async {
    List<FirestoreMovieWatchlistDetails> nextPageMovieResults = <FirestoreMovieWatchlistDetails>[];
    try {
      var query = await _movies
          .doc(_auth.currentUser?.uid)
          .collection('watchlist')
          .orderBy('added_to_list_date', descending: true)
          .limit(18)
          .startAfter([lastItemInList.timestampAddedToFirestore]).get();
      for (var doc in query.docs) {
        nextPageMovieResults.add(
          FirestoreMovieWatchlistDetails.fromSnapshot(doc),
        );
      }
      return nextPageMovieResults;
    } catch (e) {
      log("Pagination movie watchlist ERROR: $e");
      throw e.toString();
    }
  }

  //Pagination for lists
  Future<List<FirestoreMovieWatchedDetails>> getMovieWatchedNextPage(
      FirestoreMovieWatchedDetails lastItemInList) async {
    List<FirestoreMovieWatchedDetails> nextPageMovieResults = <FirestoreMovieWatchedDetails>[];
    try {
      var query = await _movies
          .doc(_auth.currentUser?.uid)
          .collection('watched')
          .orderBy('added_to_list_date', descending: true)
          .limit(18)
          .startAfter([lastItemInList.timestampAddedToFirestore]).get();
      for (var doc in query.docs) {
        nextPageMovieResults.add(
          FirestoreMovieWatchedDetails.fromSnapshot(doc),
        );
      }
      return nextPageMovieResults;
    } catch (e) {
      log("Pagination movie watched ERROR: $e");
      throw e.toString();
    }
  }

  //For checking if movie is in whole watchlist
  Future<List<String>> allTitlesInWatchlist() async {
    try {
      List<String> allMovieTitlesInWatchlist = [];
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _users.doc(_auth.currentUser?.uid).get() as DocumentSnapshot<Map<String, dynamic>>;
      if (doc.data() != null && doc.data()!.isNotEmpty) {
        for (var movie in doc.data()!["movie_watchlist"]) {
          allMovieTitlesInWatchlist.add(movie as String);
        }
      }
      return allMovieTitlesInWatchlist;
    } catch (e) {
      log("Getting all titles watchlist ERROR: $e");
      throw e.toString();
    }
  }

  Future<List<String>> allTitlesInWatched() async {
    try {
      List<String> allMovieTitlesInWatched = [];
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _users.doc(_auth.currentUser?.uid).get() as DocumentSnapshot<Map<String, dynamic>>;
      if (doc.data() != null && doc.data()!.isNotEmpty) {
        for (var movie in doc.data()!["movie_watched"]) {
          allMovieTitlesInWatched.add(movie as String);
        }
      }
      return allMovieTitlesInWatched;
    } catch (e) {
      log("Getting all titles watched ERROR: $e");
      throw e.toString();
    }
  }

  Future<FirestoreMovieWatchedDetails> showUserReview({
    required String title,
    required int tmdbId,
  }) async {
    try {
      var documentSnapshot = await _movies
          .doc(_auth.currentUser?.uid)
          .collection('watched')
          .doc("${title.replaceAll('/', ' ')}_$tmdbId")
          .get();
      return FirestoreMovieWatchedDetails.fromSnapshot(documentSnapshot);
    } catch (e) {
      log("Getting user review ERROR: $e");
      throw e.toString();
    }
  }
}
