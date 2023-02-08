import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
  ]);
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Stream<User?> userAuthState() => _auth.userChanges();

  Future<void> registerUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _users.doc(userCredential.user?.uid).set({
        "uid": userCredential.user?.uid,
        "email": email,
        "full_name": fullName,
        "account_created_date": Timestamp.now(),
        "watchlist": [],
        "watched": [],
        "watched_length": 0,
        "watchlist_length": 0,
      });
    } catch (e) {
      log(e.toString());
      throw 'There was an error creating your account';
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      throw 'There was an error signing in';
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleSignInAccount?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      DocumentSnapshot userDocSnap = await _users.doc(userCredential.user?.uid).get();
      if (!userDocSnap.exists) {
        await _users.doc(userCredential.user?.uid).set({
          "uid": userCredential.user?.uid,
          "email": googleSignInAccount?.email ?? '',
          "full_name": googleSignInAccount?.displayName ?? '',
          "account_created_date": Timestamp.now(),
          "watchlist": [],
          "watched": [],
          "watched_length": 0,
          "watchlist_length": 0,
        });
      }
    } catch (e) {
      log(e.toString());
      throw 'There was an error signing in with your Google account';
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      throw 'There was an error resetting your password';
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      log(e.toString());
      throw 'There was an error signing you out';
    }
  }

  Future<void> deleteUser({String? password}) async {
    try {
      //Before deleting account user needs to login again
      String? userLoginService = _auth.currentUser?.providerData.first.providerId;
      if (userLoginService == 'password') {
        await signInWithEmailAndPassword(
          email: _auth.currentUser?.email ?? '',
          password: password ?? '',
        );
      } else if (userLoginService == 'google.com') {
        await signInWithGoogle();
      }

      await _users.doc(_auth.currentUser?.uid).delete();
      if (userLoginService == 'google.com') {
        await _googleSignIn.signOut();
      }
      await _auth.currentUser?.delete();
    } catch (e) {
      log(e.toString());
      throw 'There was an error deleting your account';
    }
  }
}
