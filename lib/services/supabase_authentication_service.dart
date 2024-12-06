import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:masiha_doctor/consts/toast.dart';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;

  Future<void> syncFirebaseAuthWithSupabase() async {
    try {
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw Exception('No Firebase user found');
      }

      // Get Firebase ID token and handle null case
      final idToken = await firebaseUser.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      final email = firebaseUser.email;
      if (email == null) {
        throw Exception('Firebase user email is required');
      }

      // Generate a secure password using Firebase UID and token
      final securePassword = '${firebaseUser.uid}_${idToken.substring(0, 20)}';

      // Sign in to Supabase using generated password
      try {
        await supabase.auth.signInWithPassword(
          email: email,
          password: securePassword,
        );
      } catch (error) {
        if (error is AuthException &&
            (error.statusCode == 400 || error.statusCode == 404)) {
          // If user doesn't exist, create one
          await supabase.auth.signUp(
            email: email,
            password: securePassword,
            data: {
              'firebase_uid': firebaseUser.uid,
            },
          );
        } else {
          rethrow;
        }
      }
    } catch (e) {
      showToast(message: 'Failed to sync with Supabase: $e');
      rethrow;
    }
  }

  Future<void> signOutFromSupabase() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      showToast(message: 'Error signing out from Supabase: $e');
      rethrow;
    }
  }

  Future<bool> ensureSupabaseAuthenticated() async {
    try {
      final session = supabase.auth.currentSession;

      if (session == null) {
        await syncFirebaseAuthWithSupabase();
        return true;
      }

      // Check if session is expired or about to expire
      final expiresAt = session.expiresAt;
      if (expiresAt != null) {
        final expiryDateTime =
            DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
        if (expiryDateTime
            .isBefore(DateTime.now().add(const Duration(minutes: 5)))) {
          await syncFirebaseAuthWithSupabase();
        }
      }

      return true;
    } catch (e) {
      showToast(message: 'Authentication check failed: $e');
      return false;
    }
  }

  // Helper method to get current session
  Session? getCurrentSession() {
    return supabase.auth.currentSession;
  }

  // Helper method to check if user is authenticated
  bool isAuthenticated() {
    return supabase.auth.currentSession != null;
  }
}
