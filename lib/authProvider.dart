import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;
  String? _userName;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthProvider() {
    _initializeUser();
  }

  String? get userName => _userName;

  Future<void> _initializeUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      _userName = userDoc.get('name');
    }
    notifyListeners();
  }

  Future<UserCredential> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Fetch user name from Firestore
      if (_user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
        _userName = userDoc.get('name');
      }

      notifyListeners();
      return userCredential;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Save the user's name in Firestore
      await _firestore.collection('users').doc(_user!.uid).set({'name': name});

      // Fetch the username after registration
      _userName = name;
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
    _user = null;
    _userName = null;
    notifyListeners();
  }
}
