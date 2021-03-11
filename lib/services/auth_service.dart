import 'dart:async';

import 'package:beacon/models/beacon_model.dart';
import 'package:beacon/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  UserModel currentUser;
  var controller = StreamController<UserModel>();

  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  Stream<UserModel> get userChanges {
    return controller.stream;
  }

  User get getUserId => _firebaseAuth.currentUser;
  UserModel get getUser => currentUser;

  get us => null;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      var doc =
          await _fireStoreDataBase.collection('users').doc(user.user.uid).get();

      controller.add(UserModel(
          user.user.uid,
          doc.data()['firstName'],
          doc.data()['lastName'],
          doc.data()['email'],
          BeaconModel(
              doc.data()['beacon/lat'].toString(),
              doc.data()['beacon/long'].toString(),
              doc.data()['beacon/desc'],
              typeFromString("Type.active"),
              doc.data()['beacon/active'])));
      return "";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    try {
      UserCredential userCred = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user.uid)
          .set({'firstName': firstName, 'lastName': lastName, 'email': email});

      return "";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
