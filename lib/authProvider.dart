import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  List<String> _favorites = [];

  User? get user => _user;
  List<String> get favorites => _favorites;

  AuthProvider() {
    _fetchUser();
  }

  /// Fetch the current Firebase user and update local state
  void _fetchUser() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      fetchFavorites();
    }
  }

  /// Fetches the user's favorite URLs from Firestore
  Future<void> fetchFavorites() async {
    if (_user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)  // Fetch using UID
          .get();

      if (userDoc.exists) {
        _favorites = List<String>.from(userDoc.get('favorites') ?? []);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }


  /// Adds a favorite URL to Firestore and updates local state
  Future<void> addFavorite(String url) async {
    if (_user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)  // Uses UID as document ID
            .update({
          'favorites': FieldValue.arrayUnion([url])
        });

        _favorites.add(url);
        notifyListeners();
      } catch (e) {
        print('Error adding favorite: $e');
      }
    }
  }

  Future<void> removeFavorite(String url) async {
    if (_user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)  // Uses UID as document ID
            .update({
          'favorites': FieldValue.arrayRemove([url])
        });

        _favorites.remove(url);
        notifyListeners();
      } catch (e) {
        print('Error removing favorite: $e');
      }
    }
  }


  /// Handles user login and fetches data from Firestore
  Future<UserCredential> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = FirebaseAuth.instance.currentUser;
      await _fetchUserDetails();  // Fetch user details from Firestore

      notifyListeners();
      return userCredential;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logs out the user and clears local state
  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _favorites = [];
    notifyListeners();
  }

  /// Registers a new user, stores their details in Firestore, and updates FirebaseAuth display name
  Future<void> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user;

      if (_user != null) {
        await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
          'uid': _user!.uid,  // Ensures the UID is stored correctly
          'name': name,
          'email': _user!.email,
          'profileImageUrl': '',
          'favorites': [],
        });

        await _user!.updateDisplayName(name);
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }


  /// Fetches the user's name and favorites from Firestore
  Future<void> _fetchUserDetails() async {
    if (_user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          String? userName = userData['name'];
          if (userName != null) {
            await _user!.updateDisplayName(userName);
            print('User name updated: $userName');
          } else {
            print('Name field does not exist.');
          }

          _favorites = List<String>.from(userData['favorites'] ?? []);
        }
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
}
