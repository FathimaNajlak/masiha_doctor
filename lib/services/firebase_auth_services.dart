import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Existing Google Sign-In method
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      return authResult.user;
    } catch (error) {
      print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $error')),
      );
      return null;
    }
  }

  // New method for email and password sign in
  Future<User?> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } catch (error) {
      print('Email Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-In failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (error) {
      print('Sign Out Error: $error');
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
