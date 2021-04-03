import 'dart:async';

import 'package:beacon/models/beacon_model.dart';
import 'package:beacon/models/friend_model.dart';
import 'package:beacon/models/group_model.dart';
import 'package:beacon/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<String> signIn({String email, String password}) async {
    List<String> friends = [];
    List<String> friendsRequestsSent = [];
    List<String> friendsRequestsRecieved = [];


    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      var doc =
          await _fireStoreDataBase.collection('users').doc(user.user.uid).get();

      if (doc.data()['friends'] != null) {
        friends = List.from(doc.data()['friends']);
      };

      if (doc.data()['friendRequestsSent'] != null) {
        friendsRequestsSent = List.from(doc.data()['friends']);
      };

      if (doc.data()['friendsRequestsRecieved'] != null) {
        friendsRequestsRecieved = List.from(doc.data()['friends']);
      };

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
              doc.data()['beacon/active']),

          //THIS IS A TEMP CREAETED LIST FOR DEMO PURPOSES NEED TO STORE THE GROUPS ON THE SERVER SOMEHOW
          [
            GroupModel(members: [Friend(name: 'will'), Friend(name: 'Richie')], icon: (Icons.accessible), name: ('squad #1')),
            GroupModel(members: [Friend(name: 'beth'), Friend(name: 'john'), Friend(name: 'john')], icon: (Icons.height), name: ('squad 2')),
            GroupModel(members: [Friend(name: 'Frankie'), Friend(name: 'Megan')], icon: (Icons.eject), name: ('squad 3')),
            GroupModel(members: [Friend(name: 'Robbie'), Friend(name: 'Richie'), Friend(name: 'john')], icon: (Icons.accessible), name: ('squad 4')),
            GroupModel(members: [Friend(name: 'Yvie'), Friend(name: 'john'), Friend(name: 'john')], icon: (Icons.accessible), name: ('squad 5')),
          ],
        friends,
        friendsRequestsSent,
        friendsRequestsRecieved,
        )
      );
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
          .set({'firstName': firstName,
                'lastName': lastName,
                'email': email,
                'userId':  userCred.user.uid.toString(),
                'nameSearch': setSearchParam(firstName, lastName)
          });

      return "";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
