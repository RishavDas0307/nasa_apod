import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  List<String> _favorites = [];

  User? get user => _user;

  List<String> get favorites => _favorites;

  Future<void> fetchFavorites() async {
    if (_user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        _favorites = List<String>.from(userDoc.get('favorites') ?? []);
        notifyListeners();
      }
    }
  }

  Future<void> addFavorite(String url) async {
    if (_user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({
        'favorites': FieldValue.arrayRemove([url])
      });
      _favorites.remove(url);
      notifyListeners();
    }
  }

  Future<UserCredential> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Fetch user name and favorites from Firestore
      if (_user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null && userData.containsKey('name')) {
            String userName = userData['name'];
            await _user!.updateDisplayName(userName);
            print('User name: $userName');
          } else {
            print('Name field does not exist.');
          }
          _favorites = List<String>.from(userData?['favorites'] ?? []);
        } else {
          print('User document does not exist.');
        }
      }

      notifyListeners();
      return userCredential;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _favorites = [];
    notifyListeners();
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Save user name to Firestore and set displayName
      if (_user != null) {
        await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
          'name': name,
          'favorites': [],
        });
        await _user!.updateDisplayName(name);
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}