import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInit;
  User? _user;
  bool _isLoading = true; // Start loading until we verify auth state

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInit ??= _googleSignIn.initialize(
      serverClientId: '842196609831-48gn3719b9fet7dat5ro5voqja6pjrrs.apps.googleusercontent.com',
    );
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _updateUserDocument(cred.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _updateUserDocument(cred.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      await _googleSignIn.signOut(); // Clear any corrupted states
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      await _updateUserDocument(cred.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateUserDocument(User? user) async {
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Failed to update user document: $e");
    }
  }

  Future<void> uploadProfilePhoto(File imageFile) async {
    final currentUser = _user;
    if (currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users_profile_photos')
          .child('${currentUser.uid}.jpg');

      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firebase Auth
      await currentUser.updatePhotoURL(downloadUrl);
      // Reload user to get updated data
      await currentUser.reload();
      _user = _auth.currentUser;

      // Update Firestore
      await _updateUserDocument(_user);
    } catch (e) {
      debugPrint("Failed to upload profile photo: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

