import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/login_state.dart';

class Authenticator {
  const Authenticator();

  // Getter to retrieve the current user from FirebaseAuth
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // Getter to retrieve the current user's ID
  String? get userId => currentUser?.uid;

  // Getter to check if a user is already logged in
  bool get isAlreadyLoggedIn => userId != null;

  // Getter to retrieve the display name of the current user, or an empty string if not available
  String get displayName => currentUser?.displayName ?? '';

  // Getter to retrieve the email of the current user, or null if not available
  String? get email => currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut(); // Sign out from FirebaseAuth
    await GoogleSignIn().signOut(); // Sign out from GoogleSignIn
  }

  Future<LoginState> loginWithGoogle() async {
    // Create an instance of GoogleSignIn with the specified scopes
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email', // Request access to the user's email
      ],
    );

    final signInAccount = await googleSignIn.signIn();

    if (signInAccount == null) {
      return LoginState.error;
    }

    final googleAuth = await signInAccount.authentication;

    // Create OAuth credentials using the access token and ID token
    final oAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      final user = currentUser;
      if (user != null) {
        await _storeUserInFirestore(user);
      }
      return LoginState.success;
    } catch (e) {
      return LoginState.error;
    }
  }

  Future<void> _storeUserInFirestore(User user) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'displayName': user.displayName ?? '',
          'email': user.email ?? '',
        });
      }
    } catch (e) {
      print('Error storing user in Firestore: $e');
      rethrow;
    }
  }
}
