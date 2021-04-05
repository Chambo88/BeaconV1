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

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  void addUserModelToController(DocumentSnapshot doc) {
    UserModel user = UserModel.fromDocument(doc);
    print("is the user active ${user.beacon.active} , /n"
        "what type is it ${user.beacon.type}");
    controller.add(user);
    //   (
    //   user.user.uid,
    //   doc.data()['firstName'],
    //   doc.data()['lastName'],
    //   doc.data()['email'],
    //   BeaconModel(
    //       doc.data()['beacon/lat'].toString(),
    //       doc.data()['beacon/long'].toString(),
    //       doc.data()['beacon/desc'],
    //       typeFromString("Type.active"),
    //       doc.data()['beacon/active']),
    //
    //   //THIS IS A TEMP CREAETED LIST FOR DEMO PURPOSES NEED TO STORE THE GROUPS ON THE SERVER SOMEHOW
    //   [
    //     GroupModel(members: [Friend(name: 'will'), Friend(name: 'Richie')], icon: (Icons.accessible), name: ('squad #1')),
    //     GroupModel(members: [Friend(name: 'beth'), Friend(name: 'john'), Friend(name: 'john')], icon: (Icons.height), name: ('squad 2')),
    //     GroupModel(members: [Friend(name: 'Frankie'), Friend(name: 'Megan')], icon: (Icons.eject), name: ('squad 3')),
    //     GroupModel(members: [Friend(name: 'Robbie'), Friend(name: 'Richie'), Friend(name: 'john')], icon: (Icons.accessible), name: ('squad 4')),
    //     GroupModel(members: [Friend(name: 'Yvie'), Friend(name: 'john'), Friend(name: 'john')], icon: (Icons.accessible), name: ('squad 5')),
    //   ],
    //   [],
    //   [],
    //   [],
    // )
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
    // List<String> friends = [];
    // List<String> sentFriendRequests = [];
    // List<String> recievedFriendRequests = [];


    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // var doc =
      //     await _fireStoreDataBase.collection('users').doc(user.user.uid).get();

      // friends = List.from(doc.data()['friends']);
      // sentFriendRequests = List.from(doc.data()['friendRequestsSent']);
      // recievedFriendRequests = List.from(doc.data()['friendsRequestsRecieved']);
      print('got to here');

      // controller.add(UserModel(
      //     user.user.uid,
      //     doc.data()['firstName'],
      //     doc.data()['lastName'],
      //     doc.data()['email'],
      //     BeaconModel(
      //         doc.data()['beacon/lat'].toString(),
      //         doc.data()['beacon/long'].toString(),
      //         doc.data()['beacon/desc'],
      //         typeFromString("Type.active"),
      //         doc.data()['beacon/active']),
      //
      //     //THIS IS A TEMP CREAETED LIST FOR DEMO PURPOSES NEED TO STORE THE GROUPS ON THE SERVER SOMEHOW
      //     [
      //       GroupModel(members: [Friend(name: 'will'), Friend(name: 'Richie')], icon: (Icons.accessible), name: ('squad #1')),
      //       GroupModel(members: [Friend(name: 'beth'), Friend(name: 'john'), Friend(name: 'john')], icon: (Icons.height), name: ('squad 2')),
      //       GroupModel(members: [Friend(name: 'Frankie'), Friend(name: 'Megan')], icon: (Icons.eject), name: ('squad 3')),
      //       GroupModel(members: [Friend(name: 'Robbie'), Friend(name: 'Richie'), Friend(name: 'john')], icon: (Icons.accessible), name: ('squad 4')),
      //       GroupModel(members: [Friend(name: 'Yvie'), Friend(name: 'john'), Friend(name: 'john')], icon: (Icons.accessible), name: ('squad 5')),
      //     ],
      //   [],
      //   [],
      //   [],
      //   )

      // );
      print('got to here 2');
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
                'nameSearch': setSearchParam(firstName, lastName),
                'sentFriendRequests' : [],
                'recievedFriendRequests' : [],
                'friends' : [],
          });

      return "";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
