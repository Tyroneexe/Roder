import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  bool _isSignedIn = false; // Flag to track sign-in status

  GoogleSignInAccount get user => _user!;
  bool get isSignedIn => _isSignedIn; // Getter for sign-in status

  Future<void> googleLogIn() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    _isSignedIn = true; // Set the flag to indicate sign-in
    notifyListeners();
  }

  Future<void> logout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    _isSignedIn = false; // Reset the flag on logout
    notifyListeners();
  }
}
