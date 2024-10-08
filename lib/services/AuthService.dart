import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth? _firebaseAuth;
  // UserModel currentUser;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth!.authStateChanges();

  User get getUserId => _firebaseAuth!.currentUser!;

  // UserModel get getUser => currentUser;

  get us => null;

  Future signOut() async {
    try {
      return await _firebaseAuth!.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void addUserModelToController(DocumentSnapshot doc) {
    // UserModel user = UserModel.fromDocument(doc);
  }

  List<String> setSearchParam(String firstName, String lastName) {
    List<String> caseSearchList = [];
    String userName = (firstName + lastName).toLowerCase();
    lastName = lastName.toLowerCase();
    String temp = "";
    for (int i = 0; i < userName.length; i++) {
      temp = temp + userName[i];
      caseSearchList.add(temp);
    }
    temp = "";
    for (int i = 0; i < lastName.length; i++) {
      temp = temp + lastName[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  Future<String> signIn({String? email, String? password}) async {
    try {
      await _firebaseAuth!
          .signInWithEmailAndPassword(email: email!, password: password!);
      return "";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signUp(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    try {
      // Jordan is cool
      UserCredential userCred = await _firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'userId': userCred.user!.uid.toString(),
        'nameSearch': setSearchParam(firstName, lastName),
        'sentFriendRequests': [],
        'receivedFriendRequests': [],
        'friends': [],
        'groups': [],
      });

      return "";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
